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

local function pick_inspection_profile()
	local inspection_profile = require("nautilus.custom.inspection-profile")
	local core = require("nautilus.core.functions")
	local items = inspection_profile.all()

	core.select_with_snacks(items, {
		prompt = "Inspection Profile",
		format_item = function(item)
			if item == inspection_profile.get() then return item .. " (current)" end
			return item
		end,
		empty_message = "No inspection profiles available",
	}, function(choice)
		if not choice then return end
		vim.cmd("InspectionProfile " .. choice)
	end)
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

						local function trim_empty(lines)
							local start_idx, end_idx = 1, #lines
							while start_idx <= #lines and lines[start_idx]:match("^%s*$") do
								start_idx = start_idx + 1
							end
							while end_idx >= 1 and lines[end_idx]:match("^%s*$") do
								end_idx = end_idx - 1
							end
							if end_idx < start_idx then return {} end
							local out = {}
							for i = start_idx, end_idx do
								table.insert(out, lines[i])
							end
							return out
						end

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
						local lines = {}

						if is_fresh_repo then
							local empty_tree = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
							local staged = vim.fn.systemlist({
								"git",
								"-C",
								git_root,
								"--no-pager",
								"diff",
								"--cached",
								"--stat",
								empty_tree,
							})
							local unstaged = vim.fn.systemlist({
								"git",
								"-C",
								git_root,
								"--no-pager",
								"diff",
								"--stat",
							})

							if vim.tbl_isempty(staged) and vim.tbl_isempty(unstaged) then return {} end

							table.insert(lines, "No commits yet")
							table.insert(lines, "")
							table.insert(lines, "First-commit summary:")
							if not vim.tbl_isempty(staged) then
								table.insert(lines, "Staged:")
								vim.list_extend(lines, staged)
							end
							if not vim.tbl_isempty(staged) and not vim.tbl_isempty(unstaged) then table.insert(lines, "") end
							if not vim.tbl_isempty(unstaged) then
								table.insert(lines, "Unstaged:")
								vim.list_extend(lines, unstaged)
							end
						else
							local diff = vim.fn.systemlist({
								"git",
								"-C",
								git_root,
								"--no-pager",
								"diff",
								"--stat",
								"-B",
								"-M",
								"-C",
							})
							if vim.v.shell_error ~= 0 or vim.tbl_isempty(diff) then return {} end
							lines = diff
						end

						lines = trim_empty(lines)
						if vim.tbl_isempty(lines) then return {} end

						return {
							pane = 2,
							enabled = true,
							padding = 1,
							indent = 3,
							icon = " ",
							title = "Git Status",
							{
								text = lines,
							},
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
				"<leader>pa",
				function() vim.cmd("Action") end,
				desc = "[P]roject [A]ctions",
			},
			{
				"<leader>pt",
				function() vim.cmd("TemplateNew") end,
				desc = "[P]roject [T]emplates",
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
				"<leader>uI",
				pick_inspection_profile,
				desc = "Pick inspection profile",
			},
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
