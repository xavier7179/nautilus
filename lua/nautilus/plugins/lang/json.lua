local lang = require("nautilus.custom.lang")

return {
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("json"),
		dependencies = { "b0o/SchemaStore.nvim" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.jsonls = vim.tbl_deep_extend("force", opts.servers.jsonls or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("json"),
				init_options = {
					provideFormatter = false, -- conform handles formatting
				},
				before_init = function(_, new_config)
					new_config.settings = new_config.settings or {}
					new_config.settings.json = new_config.settings.json or {}
					new_config.settings.json.schemas = require("schemastore").json.schemas()
				end,
			})

			return opts
		end,
	},
}
