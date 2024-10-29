return {
	{
		"voldikss/vim-floaterm",
		config = function()
			vim.keymap.set(
				"n",
				"<leader>ot",
				"<cmd>:FloatermNew --height=0.8 --width=0.9 --wintype=float --name=terminal --position=center --autoclose=2<CR>",
				{ desc = "[O]pen Float[T]erm" }
			)
			vim.keymap.set("n", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
			vim.keymap.set("t", "<leader>tt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
		end,
	},
}
