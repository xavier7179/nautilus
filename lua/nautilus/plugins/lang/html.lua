local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("html"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.html = vim.tbl_deep_extend("force", opts.servers.html or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("html"),
				init_options = {
					provideFormatter = false, -- conform handles formatting
				},
			})

			return opts
		end,
	},
}
