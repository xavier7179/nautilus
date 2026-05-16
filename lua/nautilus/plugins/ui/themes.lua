return require("nautilus.custom.colorscheme").lazy_setup({
	{
		"folke/tokyonight.nvim",
		opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				cmp = true,
				gitsigns = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = false },
				neotree = false,
				overseer = true,
				noice = true,
				snacks = true,
				treesitter = true,
				treesitter_context = true,
			},
		},
	},
})
