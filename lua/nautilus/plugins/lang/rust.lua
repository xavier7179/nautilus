local diagnostics = vim.g.nautilus_rust_diagnostics or "rust-analyzer"

return {
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"mason-org/mason.nvim",
		optional = true,
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "codelldb" })

			if diagnostics == "bacon-ls" then vim.list_extend(opts.ensure_installed, { "bacon", "bacon-ls" }) end
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,
		ft = { "rust" },
		opts = function()
			return {
				server = {
					on_attach = function(_, bufnr)
						vim.keymap.set(
							"n",
							"cR",
							function() vim.cmd.RustLsp("codeAction") end,
							{ desc = "Rust Code Action", buffer = bufnr }
						)

						vim.keymap.set(
							"n",
							"dr",
							function() vim.cmd.RustLsp("debuggables") end,
							{ desc = "Rust Debuggables", buffer = bufnr }
						)
					end,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								buildScripts = {
									enable = true,
								},
							},
							diagnostics = {
								enable = diagnostics == "rust-analyzer",
							},
							checkOnSave = {
								enable = diagnostics == "rust-analyzer",
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},
							files = {
								excludeDirs = {
									".direnv",
									".git",
									".github",
									".gitlab",
									"bin",
									"node_modules",
									"target",
									"venv",
									".venv",
								},
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local package_path = require("mason-registry").get_package("codelldb"):get_install_path()
			local codelldb = package_path .. "/extension/adapter/codelldb"

			local library_path
			if vim.loop.os_uname().sysname == "Linux" then
				library_path = package_path .. "/extension/lldb/lib/liblldb.so"
			elseif vim.loop.os_uname().sysname == "Darwin" then
				library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
			else
				library_path = package_path .. "/extension/lldb/bin/liblldb.dll"
			end

			opts.dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
			}

			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		ft = { "rust" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.rust_analyzer = { enabled = false }

			if diagnostics == "bacon-ls" then
				opts.servers.bacon_ls = {
					init_options = {
						updateOnSave = true,
					},
				}
			end

			return opts
		end,
	},
}
