return {
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		config = function()
			-- Set colorscheme
			-- vim.cmd("colorscheme onedark")
			-- Color Scheme Setup
			-- Options
			require("onedarkpro").setup({
				highlights = {
					Comment = { italic = true },
					Directory = { bold = true },
					ErrorMsg = { italic = true, bold = true },
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
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
				navic = { enabled = true, custom_bg = "lualine" },
				neotree = false,
				overseer = true,
				noice = true,
				snacks = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
			},
		},
	},
	{ "yunlingz/equinusocio-material.vim", name = "equinuscio-material" },
}
