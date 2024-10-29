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
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
