return {
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "yaml", "yml" },
		dependencies = {
			"b0o/SchemaStore.nvim",
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.yamlls = {
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
			}

			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.yaml = { "yamllint" }
			opts.linters_by_ft.yml = { "yamllint" }
			return opts
		end,
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft or {})
		end,
	},
}
