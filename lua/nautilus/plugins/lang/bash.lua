local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("bash"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			opts.servers.bashls = vim.tbl_deep_extend("force", opts.servers.bashls or {}, {
				capabilities = capabilities,
				filetypes = lang.ft("bash"),
			})

			return opts
		end,
	},

	{
		"mfussenegger/nvim-dap",
		optional = true,
		ft = lang.ft("bash"),
		config = function()
			local dap = require("dap")
			if dap.adapters.bashdb then return end

			local install_path = vim.fn.expand("$MASON/packages/bash-debug-adapter")

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
