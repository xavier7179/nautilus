-- Local-edit, explicit-push workflow for projects that live on a remote
-- host (the JetBrains "Deployment" mental model: a real local working copy,
-- edited with full local tooling, pushed to the remote only when asked).
--
-- Deliberately NOT built on remote-sshfs.nvim/sshfs: that mounts the remote
-- filesystem and edits it live over the network, which is a different tool
-- for a different job (and the source of most of this session's bugs). This
-- module never touches the remote except during an explicit push/pull, via
-- plain rsync-over-ssh -- no mount, no FUSE, no persistent connection to
-- leak or freeze on.
--
-- Per-project config: a `.nvim-deploy.lua` file at the project root,
-- discovered by walking up from the current buffer (same shape as LSP root
-- detection), e.g.:
--
--   return {
--     host = "molesystem",                          -- SSH config Host alias
--     remote_path = "/www-data/www/www.sandralang.cc",
--     excludes = { "uploads/", "cache/" },           -- merged with the defaults below
--     delete = false,                                -- push only: pass --delete to rsync
--   }

local M = {}

local CONFIG_FILENAME = ".nvim-deploy.lua"

-- Always excluded, on top of whatever the project config adds.
local DEFAULT_EXCLUDES = { ".git/", ".DS_Store", CONFIG_FILENAME }

---Find and load the `.nvim-deploy.lua` for the given buffer, walking up
---from its directory (or cwd, if the buffer has no file) toward $HOME.
---@param bufnr integer
---@return {root: string, config: table}|nil
function M.find_config(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local start_dir = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.fn.getcwd()

	local found = vim.fs.find(CONFIG_FILENAME, {
		upward = true,
		path = start_dir,
		stop = vim.uv.os_homedir(),
	})[1]
	if not found then return nil end

	local root = vim.fn.fnamemodify(found, ":p:h")
	local chunk, load_err = loadfile(found)
	if not chunk then
		vim.notify("[deploy] " .. CONFIG_FILENAME .. " failed to load: " .. tostring(load_err), vim.log.levels.ERROR)
		return nil
	end

	local ok, config = pcall(chunk)
	if not ok then
		vim.notify("[deploy] " .. CONFIG_FILENAME .. " raised an error: " .. tostring(config), vim.log.levels.ERROR)
		return nil
	end
	if type(config) ~= "table" or not config.host or not config.remote_path then
		vim.notify(
			"[deploy] " .. CONFIG_FILENAME .. " must return a table with `host` and `remote_path`",
			vim.log.levels.ERROR
		)
		return nil
	end

	return { root = root, config = config }
end

---@param config table
---@return string[]
local function exclude_args(config)
	local excludes = vim.deepcopy(DEFAULT_EXCLUDES)
	vim.list_extend(excludes, config.excludes or {})
	local args = {}
	for _, pattern in ipairs(excludes) do
		table.insert(args, "--exclude=" .. pattern)
	end
	return args
end

---@param root string
---@param config table
---@param direction "push"|"pull"
---@param dry_run boolean
---@return string[]
local function rsync_cmd(root, config, direction, dry_run)
	-- Trailing slashes on both sides: sync the *contents* of one into the
	-- other, not a nested directory named after the source (rsync's classic
	-- footgun when this is left out).
	local local_side = root:gsub("/$", "") .. "/"
	local remote_side = config.host .. ":" .. config.remote_path:gsub("/$", "") .. "/"

	local cmd = { "rsync", "-avz" }
	if dry_run then
		table.insert(cmd, "-n")
		table.insert(cmd, "--itemize-changes")
	end
	-- --delete only ever applies to push, and only when the project config
	-- opts in: "make the remote match what I'm pushing" is a reasonable
	-- push intent, "make my local checkout match whatever's on the remote"
	-- (deleting local files to do it) is not something this module offers,
	-- regardless of the config -- pull is for reviewing/grabbing drift, not
	-- for silently discarding local work.
	if direction == "push" and config.delete then table.insert(cmd, "--delete") end
	vim.list_extend(cmd, exclude_args(config))

	if direction == "push" then
		vim.list_extend(cmd, { local_side, remote_side })
	else
		vim.list_extend(cmd, { remote_side, local_side })
	end
	return cmd
end

-- Counter, not a timestamp: two previews opened within the same second
-- (e.g. re-running push right after cancelling) would still collide on a
-- timestamp-based name, since nvim_buf_set_name requires exact uniqueness.
local preview_seq = 0

---Show itemized rsync output in a scratch buffer for review.
---@param lines string[]
---@param title string
local function show_changes(lines, title)
	vim.cmd("botright new")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	preview_seq = preview_seq + 1
	-- A prior preview buffer can still be alive (its window just hasn't been
	-- closed yet -- bufhidden=wipe only fires once it's no longer displayed
	-- anywhere), and nvim_buf_set_name errors (E95) on any name collision,
	-- even with a soon-to-be-wiped buffer. Suffix with a counter so repeat
	-- invocations never collide, instead of assuming the last preview is gone.
	vim.api.nvim_buf_set_name(buf, title .. "-" .. preview_seq)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.api.nvim_win_set_height(0, math.min(20, math.max(6, #lines + 1)))
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true })
end

---@param root string
---@param config table
---@param direction "push"|"pull"
local function run(root, config, direction)
	local dry = rsync_cmd(root, config, direction, true)
	vim.notify("[deploy] Checking what would change (" .. direction .. ")...", vim.log.levels.INFO)

	local result = vim.system(dry, { text = true, cwd = root }):wait()
	if result.code ~= 0 then
		vim.notify("[deploy] rsync dry-run failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
		return
	end

	local lines = vim.split(vim.trim(result.stdout or ""), "\n", { trimempty = true })
	if #lines == 0 then
		vim.notify("[deploy] Already in sync, nothing to " .. direction .. ".", vim.log.levels.INFO)
		return
	end

	local verb = direction == "push" and "Push" or "Pull"
	local target = direction == "push" and config.host or "local"
	show_changes(lines, "deploy://" .. direction .. "-preview")

	local warning = direction == "pull" and " (this can overwrite local changes)" or ""
	local choice = vim.fn.confirm(
		string.format("%s %d change(s) %s %s?%s", verb, #lines, direction == "push" and "to" or "from", target, warning),
		"&Yes\n&No",
		2
	)
	if choice ~= 1 then
		vim.notify("[deploy] " .. verb .. " cancelled.", vim.log.levels.WARN)
		return
	end

	local live = rsync_cmd(root, config, direction, false)
	require("snacks").terminal.open(live, { cwd = root, interactive = false })
end

---@param bufnr? integer
function M.push(bufnr)
	local found = M.find_config(bufnr or 0)
	if not found then
		vim.notify(
			"[deploy] No " .. CONFIG_FILENAME .. " found above this buffer. See lua/nautilus/custom/deploy.lua for the format.",
			vim.log.levels.ERROR
		)
		return
	end
	run(found.root, found.config, "push")
end

---@param bufnr? integer
function M.pull(bufnr)
	local found = M.find_config(bufnr or 0)
	if not found then
		vim.notify(
			"[deploy] No " .. CONFIG_FILENAME .. " found above this buffer. See lua/nautilus/custom/deploy.lua for the format.",
			vim.log.levels.ERROR
		)
		return
	end
	run(found.root, found.config, "pull")
end

return M
