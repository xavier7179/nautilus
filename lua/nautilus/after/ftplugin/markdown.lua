local o = vim.opt

vim.g.disable_autoformat = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local cmp = require("cmp")
cmp.setup({
	sources = cmp.config.sources({
		{ name = "render-markdown" },
	}),
})
