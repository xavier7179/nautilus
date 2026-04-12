local lang = require("nautilus.custom.lang")

return {
	-- Formatters
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"fp",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end,
				mode = { "n", "v" },
				desc = "[F]ormat buffer",
			},
		},
		opts = function()
			return {
				formatters_by_ft = lang.conform_by_ft(),
				formatters = {},
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
					return {
						timeout_ms = 1000,
						async = false,
						lsp_format = "fallback",
					}
				end,
			}
		end,
		init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
	},
	-- Linters
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return {
				linters_by_ft = lang.linters_by_ft(),
			}
		end,
		config = function(_, opts)
			local lint = require("lint")

			lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft or {})

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					if vim.bo.modifiable then lint.try_lint() end
				end,
			})
		end,
	},

	--{
	--	"nvimdev/guard.nvim",
	--	ft = { "c", "cpp" },
	--	dependencies = {
	--		"nvimdev/guard-collection",
	--	},
	-- },
}
