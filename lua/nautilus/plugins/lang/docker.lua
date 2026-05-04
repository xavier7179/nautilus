local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("docker"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.dockerls = vim.tbl_deep_extend("force", opts.servers.dockerls or {}, {
				settings = {
					docker = {
						languageserver = {
							telemetry = {
								enableTelemetry = false,
							},
						},
					},
				},
			})

			return opts
		end,
	},
}
