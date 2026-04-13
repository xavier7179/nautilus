return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		event = "VeryLazy",
		--lazy = false,
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
						local in_git = Snacks.git.get_root() ~= nil
						local cmds = {
							{
								icon = " ",
								title = "Git Status",
								cmd = "git --no-pager diff --stat -B -M -C",
								height = 10,
							},
						}
						return vim.tbl_map(
							function(cmd)
								return vim.tbl_extend("force", {
									pane = 2,
									section = "terminal",
									enabled = in_git,
									padding = 1,
									ttl = 5 * 60,
									indent = 3,
								}, cmd)
							end,
							cmds
						)
					end,
					{ section = "startup" },
				},
			},
			explorer = { enabled = true, replace_netrw = true },
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
							-- local core = require("nautilus.core.functions")
							source.confirm(picker, item)
							-- core.saveColorscheme(item.text)
							--require("nautilus.custom.colorscheme").save_colorscheme(item.text)
						end,
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
			terminal = { enabled = true },
			toggle = { enabled = true, which_key = false },
			words = { enabled = true },
			styles = {
				notification = {
					notification = {
						ft = "text",
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
			},
			zen = {
				on_open = function(win)
					vim.opt.number = false
					vim.opt.relativenumber = false
					require("noice").disable()
					require("ufo").disable()
					vim.o.foldcolumn = "0"
					vim.o.foldenable = false
				end,
				on_close = function(win)
					vim.opt.number = true
					vim.opt.relativenumber = true
					require("noice").enable()
					require("ufo").enable()
					vim.o.foldcolumn = "1"
					vim.o.foldenable = true
				end,
			},
		},
		keys = {
			{ "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
			{ "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
			{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
			{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
			{ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
			{ "<leader>fR", function() Snacks.rename.rename_file() end, desc = "[F]ile [R]ename" },
			{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
			{ "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
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
				end,
			})
		end,
	},
}
