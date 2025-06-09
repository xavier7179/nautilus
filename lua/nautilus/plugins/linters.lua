return {
	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				bash = { "shellcheck" },
				-- c = { "cpplint" }, -- Removed as it does not work well
				-- cpp = { "cpplint" }, -- Removed as it is fixed to Google Style
				cmake = { "cmakelint" },
				markdown = { "markdownlint-cli2" },
				sh = { "shellcheck" },
				php = { "phpcs" },
				zsh = { "shellcheck" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
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
