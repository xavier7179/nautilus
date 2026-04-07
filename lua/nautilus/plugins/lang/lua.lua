return {
	-- LSP config
	{
		"neovim/nvim-lspconfig",
		ft = { "lua" },
		opts = function(_, opts)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						format = {
							enable = false,
						},
					},
				},
			}

			return opts
		end,
	},
	{ -- Formatter
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			formatters = {
				stylua = {
					-- force stylua to avoid expading simple statement
					prepend_args = {
						"--collapse-simple-statement",
						"Always",
					},
				},
			},
		},
	},
}
