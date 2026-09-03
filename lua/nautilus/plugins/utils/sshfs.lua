-- Work around two remote-sshfs.nvim bugs on disconnect:
-- 1. RemoteSSHFSDisconnect calls unmount_host(), which shells out to the
--    Linux-only `fusermount` with no executable() guard, before it ever
--    reaches its own `umount` fallback. fuse-t (and macFUSE) don't ship
--    fusermount, so on macOS the call throws instead of failing
--    gracefully, and the mount is never released. Finish the teardown by
--    hand when that happens.
-- 2. Neither path ever cd's back out of the mount point. Since on_connect
--    changes into the mount (handlers.on_connect.change_dir above), nvim's
--    cwd is left pointing at a directory that no longer resolves once it's
--    unmounted -- every subsequent cwd-relative command (file explorer,
--    finder, :pwd) breaks with "Not a directory" until you cd manually.
local function remote_disconnect()
	local connections = require("remote-sshfs.connections")
	local mount_point = connections.get_current_mount_point()
	local ok = pcall(connections.unmount_host)
	if not ok and mount_point then
		vim.fn.system({ "umount", (mount_point:gsub("/$", "")) })
		vim.notify("[remote-sshfs] Disconnected from remote host", vim.log.levels.INFO)
	end
	-- fuse-t's go-nfsv4 loopback helper routinely survives the unmount above
	-- (both the fusermount-throws path and the manual umount fallback), and
	-- a stale helper still bound to this mount point collides with the next
	-- connect attempt, which sshfs then reports as "Killed by signal 1".
	-- Reap any leftover helper for this exact mount point so it can't.
	if mount_point then
		vim.fn.system({ "pkill", "-f", "go-nfsv4 " .. (mount_point:gsub("/$", "")) })
	end
	vim.cmd.cd(vim.fn.expand("$HOME"))
end

-- Work around a remote-sshfs.nvim bug: ui.prompt_yes_no() (used for both
-- the "connect to host?" and "add unknown host key?" confirmations)
-- unconditionally schedules `startinsert` after showing the prompt, with
-- no check on which buffer is current when that deferred call actually
-- fires. The connect flow chains a host-picker window into this y/n
-- prompt window, and once a scheduled startinsert lands on the wrong
-- buffer in that handoff, every keystroke -- including <leader> -- is
-- swallowed as literal insert-mode text: nomodifiable buffers reject it
-- with E21, modifiable ones (e.g. a real code buffer) execute it as text
-- or, once back in Normal mode, as a command (typing "y" runs yank).
-- Dropping the call outright isn't safe either -- it's also what wins a
-- race against the picker-to-prompt handoff often enough that the y/n
-- prompt is left in Normal mode without it. Guard it instead: only
-- re-assert insert mode when we're actually on the prompt buffer itself.
local function patch_prompt_yes_no()
	local ui = require("remote-sshfs.ui")
	ui.prompt_yes_no = function(prompt_input, callback)
		local result = ui.prompt(prompt_input .. " y/n: ", prompt_input, { "y", "n" }, { "Yes", "No" }, callback)
		vim.schedule(function()
			if vim.bo.buftype == "prompt" and vim.bo.modifiable then
				vim.cmd("startinsert")
			end
		end)
		return result
	end
end

-- Work around a remote-sshfs.nvim bug: handler.sshfs_wrapper() treats any
-- sshfs stdout/stderr line that isn't "ssh_askpass" or "Authenticated" as a
-- connection failure and surfaces it verbatim. jobstop() (called by every
-- disconnect path -- <leader>rd, :RemoteSSHFSDisconnect, quitting nvim with
-- unmount_on_exit) SIGTERMs the sshfs job, and sshfs prints its own normal
-- "Killed by signal 15" shutdown line as it exits. The wrapper doesn't
-- distinguish that from a genuine failure, so every deliberate disconnect
-- surfaces a spurious "Connection failed: Killed by signal ..." notification
-- even though the disconnect itself completes fine. A "Killed by signal N"
-- message can only mean something deliberately terminated the process --
-- real auth/network failures produce different text -- so it's always safe
-- to swallow just this one pattern; everything else still goes through.
--
-- Same wrapper, same story, for a second unrelated line: ssh's own
-- "** WARNING: connection is not using a post-quantum key exchange
-- algorithm" advisory. It's about the *server's* configuration (an
-- upgrade molesystem's operator would make, not something fixable from the
-- connecting side), and the connection succeeds right after it regardless
-- -- but the wrapper still surfaces it as "Connection failed: ...". ssh's
-- own convention marks these advisory banners with a leading "** ", which
-- real errors (permission denied, connection refused, timeout, host key
-- mismatch) never use, so matching that prefix is safe and general rather
-- than hardcoding just the PQ wording.
local function patch_sshfs_wrapper()
	local handler = require("remote-sshfs.handler")
	local original = handler.sshfs_wrapper
	handler.sshfs_wrapper = function(data, host, mount_dir, callback)
		local output = table.concat(data, "\n")
		if output:match("^Killed by signal") or output:match("^%*%* WARNING:") then
			return
		end
		return original(data, host, mount_dir, callback)
	end
end
return {
	"nosduco/remote-sshfs.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"RemoteSSHFSConnect",
		"RemoteSSHFSDisconnect",
		"RemoteSSHFSFindFiles",
		"RemoteSSHFSLiveGrep",
		"RemoteSSHFSEdit",
	},
	opts = {
		ui = {
			picker = "snacks",
			-- Skip the "Connect to host?" y/n prompt. It's redundant (selecting
			-- the host in the RemoteSSHFSConnect picker is already an explicit
			-- choice) and chaining it directly off that picker's still-insert-mode
			-- closing context triggers a snacks.nvim bug: Snacks.input's own
			-- confirm() captures the calling window/mode when a prompt opens and
			-- unconditionally restores Insert mode there once it closes, with no
			-- check on what buffer that window now holds. Two chained prompts
			-- (picker -> y/n confirm) hit that path reliably; a single prompt
			-- (picker alone) doesn't. Removing the second prompt removes the
			-- chain, not just papering over the symptom.
			confirm = { connect = false },
		},
		connections = {
			ssh_configs = {
				vim.fn.expand("$HOME") .. "/.ssh/config",
				"/etc/ssh/ssh_config",
			},
			-- "-o reconnect" is deliberately omitted: combined with fuse-t on
			-- macOS it sends sshfs into a busy retry loop that pegs a CPU
			-- core and floods nvim's job callback with VERBOSE log lines,
			-- freezing the UI (keystrokes silently swallowed).
			--
			-- The sshfs-fuse-t binary itself also has a separate, confirmed
			-- bug (sampled with `sample`): one of its worker threads spins in
			-- a non-blocking read() loop indefinitely -- pegging a CPU core
			-- for the life of the mount regardless of auth method or these
			-- flags. That part can't be fixed from here (it's in the C
			-- binary); disconnect (<leader>rd) when done browsing to stop it.
			-- What we CAN fix: remote-sshfs.nvim hardcodes "-o
			-- LOGLEVEL=VERBOSE" (connections.lua), so that spin also floods
			-- nvim's on_stdout job callback with log lines and freezes the
			-- UI. sshfs's -o parser keeps the last value for a repeated key,
			-- and this table is appended after the hardcoded flag, so
			-- LOGLEVEL=ERROR here silently overrides it -- no plugin patch
			-- needed, survives `:Lazy update`.
			sshfs_args = { "-o ConnectTimeout=5", "-o LOGLEVEL=ERROR" },
		},
		mounts = {
			base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
			unmount_on_exit = true,
		},
		handlers = {
			on_connect = { change_dir = true },
			on_disconnect = { clean_mount_folders = false },
		},
		log = { enabled = false },
	},
	config = function(_, opts)
		require("remote-sshfs").setup(opts)
		patch_prompt_yes_no()
		patch_sshfs_wrapper()
	end,
	keys = {
		{ "<leader>rc", "<cmd>RemoteSSHFSConnect<CR>",   desc = "[R]emote [C]onnect" },
		{ "<leader>rd", remote_disconnect,               desc = "[R]emote [D]isconnect" },
		{ "<leader>rf", "<cmd>RemoteSSHFSFindFiles<CR>", desc = "[R]emote [F]ind files" },
		{ "<leader>rg", "<cmd>RemoteSSHFSLiveGrep<CR>",  desc = "[R]emote [G]rep" },
		{ "<leader>re", "<cmd>RemoteSSHFSEdit<CR>",      desc = "[R]emote [E]dit SSH config" },
	},
}
