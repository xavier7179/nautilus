return {
	{
		"neovim/nvim-lspconfig",
		ft = { "c", "cpp" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
			}

			return opts
		end,
	},

	{
		"p00f/clangd_extensions.nvim",
		ft = { "c", "cpp" },
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				--These require codicons (https://github.com/microsoft/vscode-codicons)
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.c = { "clang_format" }
			opts.formatters_by_ft.cpp = { "clang_format" }

			opts.formatters.clang_format = function(bufnr)
				local config_path = require("nautilus.core.functions").get_file_with_path(bufnr, "clang-format")
				local args = {}

				if not vim.uv.fs_stat(config_path) then
					local shiftwidth = vim.bo[bufnr].shiftwidth
					local tabstop = vim.bo[bufnr].tabstop
					local expandtab = vim.bo[bufnr].expandtab
					local use_tab = expandtab and "Never" or "Always"
					local custom_args = string.format(
						"{BasedOnStyle: llvm, IndentWidth: %d, TabWidth: %d, UseTab: %s}",
						shiftwidth,
						tabstop,
						use_tab
					)
					table.insert(args, "--style=" .. custom_args)
				end

				return {
					cmd = "clang-format",
					args = args,
					stdin = true,
				}
			end

			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = { "c", "cpp" },
		config = function()
			local dap = require("dap")
			local mason_path = vim.fn.expand("$MASON/packages/codelldb")
			local codelldb = mason_path .. "/extension/adapter/codelldb"

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb,
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.c = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.cpp = dap.configurations.c
		end,
	},
}
