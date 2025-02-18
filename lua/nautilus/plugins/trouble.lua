return { -- Tab with issue support
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	config = function()
		require("trouble").setup({})
		vim.keymap.set(
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			{ desc = "Open/close trouble list", silent = true, noremap = true }
		)
		vim.keymap.set(
			"n",
			"<leader>xw",
			"<cmd>TroubleToggle workspace_diagnostics<cr>",
			{ desc = "Open trouble workspace diagnostics", silent = true, noremap = true }
		)
		vim.keymap.set(
			"n",
			"<leader>xd",
			"<cmd>TroubleToggle document_diagnostics<cr>",
			{ desc = "Open trouble document diagnostics", silent = true, noremap = true }
		)
		vim.keymap.set(
			"n",
			"<leader>xl",
			"<cmd>Trouble loclist toggle<cr>",
			{ desc = "Open trouble location list", silent = true, noremap = true }
		)
		vim.keymap.set(
			"n",
			"<leader>xq",
			"<cmd>Trouble quickfix toggle<cr>",
			{ desc = "Open trouble quickfix list", silent = true, noremap = true }
		)
		vim.keymap.set(
			"n",
			"<leader>xt",
			"<cmd>TodoTrouble<CR>",
			{ desc = "Open todos in trouble", silent = true, noremap = true }
		)
		vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

		-- Diagnostic signs
		-- https://github.com/folke/trouble.nvim/issues/52
		local signs = {
			Error = " ",
			Warning = " ",
			Hint = " ",
			Information = " ",
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
	end,
}
