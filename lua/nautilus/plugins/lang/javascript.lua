return {
	{
		"neovim/nvim-lspconfig",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.vtsls = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
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
			}

			return opts
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}

			opts.formatters_by_ft.javascript = { "biome" }
			opts.formatters_by_ft.javascriptreact = { "biome" }
			opts.formatters_by_ft.typescript = { "biome" }
			opts.formatters_by_ft.typescriptreact = { "biome" }
			opts.formatters_by_ft.json = { "biome" }
			opts.formatters_by_ft.css = { "biome" }
			opts.formatters_by_ft.html = { "biome" }

			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}

			opts.linters_by_ft.javascript = { "eslint" }
			opts.linters_by_ft.javascriptreact = { "eslint" }
			opts.linters_by_ft.typescript = { "eslint" }
			opts.linters_by_ft.typescriptreact = { "eslint" }

			return opts
		end,
	},

	{
		"mxsdev/nvim-dap-vscode-js",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
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
			local languages = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			}

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
}
