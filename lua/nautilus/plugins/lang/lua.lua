local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("lua"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
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
			})

			return opts
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		ft = lang.ft("lua"),
		opts = function(_, opts)
			opts = opts or {}
			opts.formatters = opts.formatters or {}

			opts.formatters.stylua = vim.tbl_deep_extend("force", opts.formatters.stylua or {}, {
				prepend_args = {
					"--collapse-simple-statement",
					"Always",
				},
			})

			return opts
		end,
	},
}
