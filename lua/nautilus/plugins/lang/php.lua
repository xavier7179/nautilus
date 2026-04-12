local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("php"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.intelephense = vim.tbl_deep_extend("force", opts.servers.intelephense or {}, {
				init_options = {
					globalStoragePath = vim.fn.stdpath("data") .. "/intelephense",
					licenceKey = nil,
					clearCache = false,
				},
				settings = {
					intelephense = {
						files = {
							maxSize = 1000000,
						},
					},
				},
			})

			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = lang.ft("php"),
		config = function()
			local dap = require("dap")
			if dap.adapters.php then return end

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
