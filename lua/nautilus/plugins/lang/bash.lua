return {
	{
		"neovim/nvim-lspconfig",
		ft = { "sh", "bash", "zsh" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.bashls = {
				capabilities = capabilities,
				filetypes = { "sh", "bash", "zsh" },
			}

			return opts
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft.sh = { "shfmt" }
			opts.formatters_by_ft.bash = { "shfmt" }
			opts.formatters_by_ft.zsh = { "shfmt" }
			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.sh = { "shellcheck" }
			opts.linters_by_ft.bash = { "shellcheck" }
			opts.linters_by_ft.zsh = { "shellcheck" }
			return opts
		end,
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft or {})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = { "sh", "bash", "zsh" },
		config = function()
			local dap = require("dap")

			if dap.adapters.bashdb then return end

			local ok, registry = pcall(require, "mason-registry")
			if not ok then return end

			local package = registry.get_package("bash-debug-adapter")
			local install_path = package:get_install_path()

			dap.adapters.bashdb = {
				type = "executable",
				command = "node",
				args = { install_path .. "/extension/out/bashDebug.js" },
			}

			dap.configurations.sh = {
				{
					type = "bashdb",
					request = "launch",
					name = "Launch Bash script",
					showDebugOutput = true,
					pathBashdb = vim.fn.exepath("bashdb"),
					pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
					trace = true,
					file = "${file}",
					program = "${file}",
					cwd = "${workspaceFolder}",
					pathCat = "cat",
					pathBash = "/bin/bash",
					pathMkfifo = "mkfifo",
					pathPkill = "pkill",
					args = {},
					env = {},
					terminalKind = "integrated",
				},
			}

			dap.configurations.bash = dap.configurations.sh
			dap.configurations.zsh = dap.configurations.sh
		end,
	},
}
