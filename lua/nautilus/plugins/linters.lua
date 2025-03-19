return {
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
				-- php = { "phpstan" },
				php = { "phpcs" },
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
