local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("c"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.clangd = vim.tbl_deep_extend("force", opts.servers.clangd or {}, {
				capabilities = capabilities,
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
			})

			return opts
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters = opts.formatters or {}
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
		"p00f/clangd_extensions.nvim",
		lazy = true,
		ft = lang.ft("c"),
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
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
		"mfussenegger/nvim-dap",
		optional = true,
		ft = lang.ft("c"),
		config = function()
			local dap = require("dap")
			if dap.adapters.codelldb then return end
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
