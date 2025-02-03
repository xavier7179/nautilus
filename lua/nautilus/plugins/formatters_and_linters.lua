return {
	{ -- Formatter
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					--			c = { "clang-format" },
					--			cpp = { "clang-format" },
					rust = { "rustfmt" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
					bibtex = { "bibtex-tidy" },
					docker = { "hadolint" },
					php = { "pretty-php", "phpstan" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "[M]ake [P]retty: Format file or range (in visual mode)" })
		end,
	},
	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				-- c = { "cpplint" }, -- Removed as it does not work well
				-- cpp = { "cpplint" }, -- Removed as it is fixed to Google Style
				cmake = { "cmakelint" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				python = { "pylint" },
				markdown = { "markdownlint" },
				php = { "phpstan" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
	{
		"nvimdev/guard.nvim",
		-- lazy load by ft
		ft = { "c", "cpp" },
		-- Builtin configuration, optional
		dependencies = {
			"nvimdev/guard-collection",
		},
	},
}
