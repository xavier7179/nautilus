return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "slant",
		},
	},
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({})
	end,
}
