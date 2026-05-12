-- Focus the nearest real file window in the current tab.
-- Scans tab windows directly instead of relying on picker.main, which can
-- resolve to the explorer list itself (buftype="" passes the file filter).
-- Falls back to picker:close() only when no real file window exists.
local function explorer_focus_editor(picker)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[buf].filetype
			local bt = vim.bo[buf].buftype
			if bt == "" and not ft:find("^snacks_picker") and ft ~= "snacks_dashboard" then
				vim.api.nvim_set_current_win(win)
				return
			end
		end
	end
	picker:close()
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			animate = { enabled = true },
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "P",
							desc = "Recent projects",
							action = ":lua Snacks.dashboard.pick('projects')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "L",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{
							icon = "",
							key = "u",
							desc = "Update Plugins",
							action = ":lua require('lazy').sync()",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = "󱌣", key = "p", desc = "Update Parsers", action = ":TSUpdate all" },
						{
							icon = "󰉼",
							key = "m",
							desc = "Update Mason",
							action = ":MasonUpdate",
							enabled = package.loaded.mason ~= nil,
						},
						{ icon = "󰋠", key = "h", desc = "Check Health", action = ":checkhealth" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						desc = "Browse Repo",
						padding = 1,
						key = "b",
						action = function() Snacks.gitbrowse() end,
					},
					function()
						-- Detect the repository root used by Snacks.
						-- If there is no git root, we hide the whole section.
						local git_root = Snacks.git.get_root()
						if not git_root then return {} end

						-- Check whether the repository already has a HEAD commit.
						-- Freshly initialized repositories do not, so they need a separate code path.
						vim.fn.system({
							"git",
							"-C",
							git_root,
							"rev-parse",
							"--verify",
							"HEAD",
						})
						local is_fresh_repo = vim.v.shell_error ~= 0

						local cmd

						if is_fresh_repo then
							-- Fresh repo path:
							-- We compute two stats:
							--   1. staged changes   -> index vs empty tree
							--   2. unstaged changes -> working tree vs index
							--
							-- If both are empty, we show a simple "Working tree clean" message.
							-- Otherwise we print each section only when it has content.
							cmd = table.concat({
								"sh -c '",
								"empty_tree=4b825dc642cb6eb9a060e54bf8d69288fbee4904;",
								"staged=$(git -C "
									.. vim.fn.shellescape(git_root)
									.. ' --no-pager diff --cached --stat "$empty_tree");',
								"unstaged=$(git -C " .. vim.fn.shellescape(git_root) .. " --no-pager diff --stat);",
								'printf "No commits yet\\n\\nFirst-commit summary:\\n";',
								'if [ -z "$staged" ] && [ -z "$unstaged" ]; then ',
								'  printf "Working tree clean\\n";',
								"else ",
								'  if [ -n "$staged" ]; then ',
								'    printf "Staged:\\n%s\\n" "$staged";',
								"  fi;",
								'  if [ -n "$staged" ] && [ -n "$unstaged" ]; then ',
								'    printf "\\n";',
								"  fi;",
								'  if [ -n "$unstaged" ]; then ',
								'    printf "Unstaged:\\n%s\\n" "$unstaged";',
								"  fi;",
								"fi'",
							}, "")
						else
							-- Normal repo path:
							-- show the usual working-tree diff summary against HEAD.
							cmd = "git -C " .. vim.fn.shellescape(git_root) .. " --no-pager diff --stat -B -M -C"
						end

						return {
							pane = 2,
							section = "terminal",
							enabled = true,
							padding = 1,
							ttl = 5 * 60,
							indent = 3,
							icon = " ",
							title = "Git Status",
							cmd = cmd,
							height = 10,
						}
					end,
					{ section = "startup" },
				},
			},
			explorer = { enabled = true, replace_netrw = true, layout = { width = 52 } },
			image = { enabled = false },
			indent = { enabled = true, char = "┊" },
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				ui_select = true,
				sources = {
					colorschemes = {
						confirm = function(picker, item)
							local source = require("snacks.picker.config.sources").colorschemes
							source.confirm(picker, item)
							require("nautilus.custom.colorscheme").save_colorscheme(item.text)
						end,
					},
					-- Override <Esc> in the explorer to focus the editor instead of closing.
					-- Applied to both the list window (normal mode) and input window (search box).
					explorer = {
						win = {
							list = {
								keys = {
									["<Esc>"] = function(picker) explorer_focus_editor(picker) end,
								},
							},
							input = {
								keys = {
									["<Esc>"] = function(picker) explorer_focus_editor(picker) end,
								},
							},
						},
					},
				},
			},
			quickfile = { enabled = true },
			scope = {
				enabled = true,
				exclude = { "markdown", "markdown_inline" },
			},
			scroll = { enabled = true },
			statuscolumn = { enabled = true, folds = { open = true } },
			terminal = {
				enabled = true,
				win = { height = 0.25 },
			},
			toggle = { enabled = true, which_key = false },
			words = { enabled = true },
			styles = {
				notification = {
					--		ft = "text",
					bo = {
						filetype = "snacks_notif",
					},
					wo = {
						wrap = true,
						conceallevel = 0,
						spell = false,
					},
				},
				notification_history = {
					ft = "text",
					bo = {
						filetype = "snacks_notif_history",
					},
					wo = {
						wrap = true,
						conceallevel = 0,
						spell = false,
					},
				},
			},
			zen = {
				on_open = function(win)
					-- Use vim.wo[win] to scope changes to the zen window only,
					-- avoiding global option leakage to other windows.
					vim.wo[win].number = false
					vim.wo[win].relativenumber = false
				pcall(function() require("noice").disable() end)
				-- nvim-origami has no disable() API; opening all folds then disabling
				-- foldenable is the equivalent: origami silently does nothing while
				-- foldenable is false.
				vim.cmd("normal! zR")
				vim.o.foldcolumn = "0"
				vim.o.foldenable = false
			end,
			on_close = function(win)
				vim.wo[win].number = true
				vim.wo[win].relativenumber = true
				pcall(function() require("noice").enable() end)
					-- Re-enabling foldenable is sufficient for origami to resume; no
					-- explicit enable() call is needed since origami is always loaded.
					vim.o.foldcolumn = "1"
					vim.o.foldenable = true
				end,
			},
		},
		keys = {
			{ "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
			{ "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
			{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
			{ "<leader>bs", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
			{ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
			{ "<leader>fR", function() Snacks.rename.rename_file() end, desc = "[F]ile [R]ename" },
			{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
			{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
			{ "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
			{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
			{ "<c-t>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
			{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
			{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
			{ "<leader>fe", function() Snacks.explorer() end, desc = "Toggle [F]ile [E]xplorer" }, -- toggle file explorer
			{
				"<leader>ue",
				function()
					-- Check if any panel is open (explorer or terminal).
					local explorer_open, terminal_open = false, false
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
						if ft == "snacks_picker_list" then explorer_open = true end
						if ft == "snacks_terminal" then terminal_open = true end
					end
					local any_open = explorer_open or terminal_open
					if any_open then
						if explorer_open then Snacks.explorer() end
						if terminal_open then Snacks.terminal.toggle() end
					else
						Snacks.explorer()
						Snacks.terminal.toggle()
					end
				end,
				desc = "Toggle panels (explorer + terminal)",
			},
			{ "<leader>sf", function() Snacks.picker.files({ layout = "telescope" }) end, desc = "[S]earch [F]iles" },
			{ "<leader>sg", function() Snacks.picker.grep({ layout = "telescope" }) end, desc = "[S]earch [G]rep" },
			{
				"<leader>sc",
				function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
				desc = "[S]earch [C]onfig File",
			},
			{
				"<leader>sw",
				function() Snacks.picker.grep_word() end,
				desc = "[S]earch [W]ord (selection)",
				mode = { "n", "x" },
			},
			{
				"<leader>sr",
				function() Snacks.picker.recent({ layout = "telescope" }) end,
				desc = "[S]earch [R]ecent",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.buffers({
						layout = "sidebar",
						preview = false,
						on_show = function(picker)
							require("nautilus.core.functions").closePickersByLayout(
								Snacks.picker.get(),
								"sidebar",
								picker
							)
						end,
					})
				end,
				desc = "[S]earch Open [B]uffers",
			},
			{
				"<leader>sB",
				function() Snacks.picker.grep_buffers({ layout = "telescope" }) end,
				desc = "[S]earch Grep Open [B]uffers",
			},
			{
				"<leader>sp",
				function() Snacks.picker.projects({ layout = "telescope" }) end,
				desc = "[S]earch [P]rojects",
			},
			{
				"<leader>sh",
				function() Snacks.picker.help({ layout = "telescope" }) end,
				desc = "[S]earch [H]elp Pages",
			},
			{
				"<leader>uC",
				function() Snacks.picker.colorschemes({ layout = "ivy" }) end,
				desc = "Pick colorschemes",
			}, -- toggle the Color schemes selection
			{
				"<leader>sk",
				function() Snacks.picker.keymaps({ layout = "ivy" }) end,
				desc = "[S]earch with [K]eymaps",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					local core = require("nautilus.core.functions")
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...) Snacks.debug.inspect(...) end
					_G.bt = function() Snacks.debug.backtrace() end
					vim.print = _G.dd -- Override print to use snacks for `:=` command
					-- get default colorscheme if available
					-- vim.cmd.colorscheme(core.getColorscheme("default"))
					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
					Snacks.toggle.profiler():map("<leader>uP")
					Snacks.toggle.animate():map("<leader>uA")
					Snacks.toggle
						.new({
							name = "Auto Fold",
							get = function() return vim.g.origami_autofold_enabled == true end,
							set = function(state)
								vim.g.origami_autofold_enabled = state
								require("origami").setup({ autoFold = { enabled = state } })
								if state then
									-- foldclose takes an optional winid (not bufnr); omit to use current window
									vim.lsp.foldclose("imports")
									vim.lsp.foldclose("comment")
								else
									vim.cmd("normal! zR")
								end
							end,
						})
						:map("<leader>uz")
				end,
			})
		end,
	},
}
