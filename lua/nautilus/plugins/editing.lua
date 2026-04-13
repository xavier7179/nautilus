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
		--	event = { "BufReadPost", "BufNewFile" },
		opts = {},
	}, -- highlight color codes in editing
	{ -- folding plugin
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "1" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then vim.lsp.buf.hover() end
			end, { desc = "Peek Fold" })

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
			})
		end,
	},
	{ -- Comments management
		"numToStr/Comment.nvim",
		keys = { "gc", "gb" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- import comment plugin safely
			local comment = require("Comment")

			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

			-- enable comment
			comment.setup({
				-- for commenting tsx, jsx, svelte, html files
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
		end,
	},
	{ -- TODO comments navigations
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
			{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
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
	{
		"preservim/vim-pencil",
		lazy = true,
		ft = { "plaintex", "markdown" },
		init = function() vim.g["pencil#wrapModeDefault"] = "soft" end,
	},
}
