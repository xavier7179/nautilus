return {
	{
		"neovim/nvim-lspconfig",
		ft = { "php" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.intelephense = {
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
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
			opts.formatters_by_ft.php = { "php_cs_fixer" }
			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.php = { "phpcs" }
			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = { "php" },
		config = function()
			local dap = require("dap")
			local path = vim.fn.expand("$MASON/packages/php-debug-adapter")
			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = { path .. "/extension/out/phpDebug.js" },
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug",
					port = 9003,
				},
				{
					type = "php",
					request = "launch",
					name = "Run current script",
					program = "${file}",
					cwd = "${fileDirname}",
					port = 9003,
					runtimeExecutable = "php",
				},
			}
		end,
	},
}
