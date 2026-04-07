return {
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
				formatters_by_ft = {},
				formatters = {
					--	stylua = {
					--		prepend_args = {
					--			"--collapse-simple-statement",
					--			"Always",
					--		},
					--	},
				},
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
}
