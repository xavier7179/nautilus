local lang = require("nautilus.custom.lang")

return {
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("yaml"),
		dependencies = {
			"b0o/SchemaStore.nvim",
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
					},
				}),
				before_init = function(_, new_config)
					new_config.settings = new_config.settings or {}
					new_config.settings.yaml = new_config.settings.yaml or {}
					new_config.settings.yaml.schemas = vim.tbl_deep_extend(
						"force",
						new_config.settings.yaml.schemas or {},
						require("schemastore").yaml.schemas()
					)
				end,
				settings = {
					redhat = {
						telemetry = {
							enabled = false,
						},
					},
					yaml = {
						keyOrdering = false,
						format = {
							enable = true,
						},
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},
					},
				},
			})

			return opts
		end,
	},
}
