local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("javascript"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("javascript"),
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			})

			return opts
		end,
	},

	{
		"mxsdev/nvim-dap-vscode-js",
		ft = lang.ft("javascript"),
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		opts = function()
			return {
				debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				adapters = {
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"node-terminal",
					"pwa-extensionHost",
				},
			}
		end,
		config = function(_, opts)
			require("dap-vscode-js").setup(opts)

			local dap = require("dap")
			local languages = lang.ft("javascript")

			for _, language in ipairs(languages) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch current file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch npm script",
						runtimeExecutable = "npm",
						runtimeArgs = { "run", "dev" },
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						console = "integratedTerminal",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch Chrome against localhost",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Electron main process",
						runtimeExecutable = "electron",
						program = "${workspaceFolder}/main.js",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
				}
			end
		end,
	},
	{
		"marilari88/neotest-vitest",
		ft = lang.ft("javascript"),
	},
	{
		"haydenmeade/neotest-jest",
		ft = lang.ft("javascript"),
	},
}
