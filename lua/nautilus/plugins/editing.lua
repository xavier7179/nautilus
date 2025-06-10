-- Editing plugins
return {
	{ "brenoprata10/nvim-highlight-colors" }, -- highlight color codes in editing
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
	-- Automatic indentation style detection
	{ "nmac427/guess-indent.nvim", opts = {} },
	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cS",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP references/definitions/... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"<leader>xt",
				"<cmd>TodoTrouble<CR>",
				{ desc = "Open todos in trouble", silent = true, noremap = true },
			},
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
		config = function()
			-- Diagnostic signs
			-- https://github.com/folke/trouble.nvim/issues/52
			local signs = {
				Error = " ",
				Warning = " ",
				Hint = " ",
				Information = " ",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type

				vim.diagnostic.config({
					signs = {
						active = {
							{ name = hl, text = icon, numhl = hl },
						},
					},
				})
			end
		end,
	},
	{ -- Comments management
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
		opts = { signs = false },
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
        },
	},
}
