-- install with yarn or npm
return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>pm",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "[M]arkdown [P]review",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},
}
