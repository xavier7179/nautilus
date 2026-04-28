-- Editing plugins
-- -- color highlight
-- -- folding
-- -- comments
-- -- sessions
-- -- writing wrappings
-- -- etc.
return {
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	}, -- highlight color codes in editing
	{ -- folding plugin
		"chrisgrieser/nvim-origami",
		event = { "BufReadPost", "BufNewFile" },
		--event = "VeryLazy",
		init = function()
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
		end,
		opts = {
			useLspFoldsWithTreesitterFallback = { enabled = true },
			pauseFoldsOnSearch = true,
			foldtext = { enabled = true },
			autoFold = { enabled = false },
			-- h/l/^/$ are overloaded: h=fold, l=unfold, ^=fold recursive, $=unfold recursive.
			-- To use dedicated keys instead, set setup=false and add:
			--   vim.keymap.set("n", "zc", function() require("origami").h() end)
			--   vim.keymap.set("n", "zo", function() require("origami").l() end)
			--   vim.keymap.set("n", "zC", function() require("origami").caret() end)
			--   vim.keymap.set("n", "zO", function() require("origami").dollar() end)
			foldKeymaps = { setup = true },
		},
		keys = {
			{ "zR", "zR", desc = "Open all folds" },
			{ "zM", "zM", desc = "Close all folds" },
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocmd = false,
		},
		init = function()
			local get_option = vim.filetype.get_option
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or get_option(filetype, option)
			end
		end,
	},
	-- Comment.nvim removed: replaced by mini.comment in plugins/utils/mini.lua,
	-- which integrates with ts_context_commentstring via custom_commentstring hook.
	{ -- TODO comments navigations
		"folke/todo-comments.nvim",
		--event = { "BufReadPost", "BufNewFile" },
		cmd = { "TodoTrouble" },
		opts = {},
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
		},
	},
	-- Sessions
	{
		"rmagatti/auto-session",
		lazy = true,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>wR", "<cmd>SessionSearch<CR>", desc = "Session search" },
			{ "<leader>wl", "<cmd>SessionRestore<CR>", desc = "Restore last session" },
			{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
			{ "<leader>uS", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
		},
		opts = {
			suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
			log_level = "error",
			auto_restore = false,
			use_git_branch = false, -- Include git branch name in session name
		},
	},
}
