local lang = require("nautilus.custom.lang")

return {
	{
		"Saecki/crates.nvim",
		ft = { "toml" },
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
		"stevearc/conform.nvim",
		optional = true,
		ft = lang.ft("rust"),
		opts = function(_, opts)
			opts = opts or {}
			opts.formatters = opts.formatters or {}

			opts.formatters.rustfmt = vim.tbl_deep_extend("force", opts.formatters.rustfmt or {}, {
				prepend_args = {},
			})

			return opts
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = vim.fn.has("nvim-0.10.0") == 0 and "^4" or false,
		ft = lang.ft("rust"),
		opts = {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set(
						"n",
						"<leader>cR",
						function() vim.cmd.RustLsp("codeAction") end,
						{ desc = "Code Action", buffer = bufnr }
					)

					vim.keymap.set(
						"n",
						"<leader>dG",
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
		},
		config = function(_, opts)
			local package_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
			local codelldb = package_path .. "/extension/adapter/codelldb"
			local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
			local uname = io.popen("uname"):read("*l")

			if uname == "Linux" then library_path = package_path .. "/extension/lldb/lib/liblldb.so" end

			opts.dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
			}

			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("rust"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.bacon_ls = vim.tbl_deep_extend("force", opts.servers.bacon_ls or {}, {
				enabled = true,
			})

			opts.servers.rust_analyzer = vim.tbl_deep_extend("force", opts.servers.rust_analyzer or {}, {
				enabled = false,
			})

			return opts
		end,
	},
	{
		"rouge8/neotest-rust",
		ft = lang.ft("rust"),
	},

	{ -- Auto-start bacon when entering a Rust project buffer
		"mrcjkb/rustaceanvim", -- piggy-back on existing plugin; no extra dep needed
		optional = true,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = lang.ft("rust"),
				desc = "Auto-start bacon in Rust project",
				callback = function()
					-- Only start once per Neovim session; skip if already running.
					if vim.g.bacon_started then return end
					local root = vim.fn.findfile("Cargo.toml", vim.fn.expand("%:p:h") .. ";")
					if root == "" then return end
					vim.fn.jobstart({ "bacon", "--headless" }, {
						cwd = vim.fn.fnamemodify(root, ":h"),
						detach = true,
					})
					vim.g.bacon_started = true
				end,
			})
		end,
	},
}
