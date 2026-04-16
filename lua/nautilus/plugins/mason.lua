local lang = require("nautilus.custom.lang")

local function merge_unique(...)
	local out = {}
	local seen = {}

	for _, list in ipairs({ ... }) do
		for _, item in ipairs(list or {}) do
			if item and not seen[item] then
				seen[item] = true
				table.insert(out, item)
			end
		end
	end

	table.sort(out)
	return out
end

return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			automatic_installation = false,
			ensure_installed = lang.dap_mason(),
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
	},

	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts) require("mason").setup(opts) end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = {
			"MasonToolsInstall",
			"MasonToolsUpdate",
			"MasonToolsClean",
			"MasonToolsUpdateSync",
			"MasonToolsInstallSync",
		},
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- Only enabled services contribute tools here.
			-- Disabled services may still be configured in the registry for readability.
			ensure_installed = merge_unique(lang.lsp_mason(), lang.format_mason(), lang.lint_mason(), lang.dap_mason()),
		},
	},
}
