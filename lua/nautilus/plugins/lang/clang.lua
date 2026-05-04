local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("c"),
		init = function()
			-- Enable inlay hints for clangd buffers on attach.
			-- Registered here (nvim-lspconfig init) so the autocmd exists before LspAttach fires,
			-- avoiding the load-order race that would occur if it were in clangd_extensions' init.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("ClangdInlayHints", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "clangd" then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end
				end,
			})
		end,
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
			ast = {
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		config = function()
			local lint = require("lint")
			lint.linters.cppcheck = vim.tbl_deep_extend("force", lint.linters.cppcheck, {
				args = function()
					local args = {
						"--enable=all",
						"--inconclusive",
						"--inline-suppr", -- honour // cppcheck-suppress comments in source
						"--quiet",
					}
					if vim.g.cppcheck_misra_enabled then
						-- Requires cppcheck's bundled misra.py addon (ships with cppcheck).
						-- For human-readable rule descriptions (e.g. "Rule 15.5 — ..."), place a
						-- misra.json file at the project root pointing to a MISRA-C rule text file:
						--   { "script": "misra.py", "args": ["--rule-texts", ".misra-rules.txt"] }
						-- Without it, diagnostics still fire but show rule IDs only (e.g. "misra-c2012-15.5").
						-- Per-project suppressions can be placed in a .cppcheck file at the project root.
						table.insert(args, "--addon=misra")
					end
					table.insert(args, "$FILENAME")
					return args
				end,
			})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = lang.ft("c"),
		-- Use init (not config) so this setup always runs regardless of which
		-- fragment's config function lazy picks when merging multiple nvim-dap specs.
		init = function()
			-- Defer until dap is actually loaded to avoid forcing an eager require.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "c", "cpp", "objc", "objcpp" },
				once = true,
				callback = function()
					vim.schedule(function()
						local ok, dap = pcall(require, "dap")
						if not ok then return end
						if dap.adapters.codelldb then return end

						local codelldb = vim.fn.stdpath("data")
							.. "/mason/packages/codelldb/extension/adapter/codelldb"

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
								program = function()
									return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
								end,
								cwd = "${workspaceFolder}",
								stopOnEntry = false,
							},
						}

						dap.configurations.cpp = dap.configurations.c
					end)
				end,
			})
		end,
	},
}
