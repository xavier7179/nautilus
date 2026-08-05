local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("python"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("python"),
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
							autoImportCompletions = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			-- ruff handles linting/imports; disable its hover so basedpyright
			-- stays the single source of hover docs (no duplicate popups).
			opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("python"),
				settings = {
					hover = { enable = false },
				},
			})

			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap-python",
		ft = lang.ft("python"),
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(debugpy)
		end,
	},

	{
		"nvim-neotest/neotest-python",
		ft = lang.ft("python"),
	},
}
