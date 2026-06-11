local lang = require("nautilus.custom.lang")

return {
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("css"),
		dependencies = { "b0o/SchemaStore.nvim" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.cssls = vim.tbl_deep_extend("force", opts.servers.cssls or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("css"),
				settings = {
					css = {
						lint = { unknownAtRules = "ignore" },
					},
					scss = {
						lint = { unknownAtRules = "ignore" },
					},
					less = {
						lint = { unknownAtRules = "ignore" },
					},
				},
				init_options = {
					provideFormatter = false, -- conform handles formatting
				},
	
			})

			return opts
		end,
	},
}
