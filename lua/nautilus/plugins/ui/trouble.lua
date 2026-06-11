return {
	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		dependencies = {
			-- "nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{
				"<leader>pd",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "[P]roject [D]iagnostics (Trouble)",
			},
			{
				"<leader>bD",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "[B]uffer [D]iagnostics (Trouble)",
			},
			{
				"<leader>ps",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "[P]roject [S]ymbols (Trouble)",
			},
			{
				"<leader>pL",
				function() require("trouble").toggle("loclist") end,
				desc = "[P]roject [L]ocation List (Trouble)",
			},
			{
				"<leader>pQ",
				function() require("trouble").toggle("qflist") end,
				desc = "[P]roject [Q]uickfix List (Trouble)",
			},
			{
				"<leader>pT",
				function() require("trouble").toggle("todo") end,
				desc = "[P]roject [T]odos list (Trouble)",
			},
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
		config = function(_, opts) require("trouble").setup(opts) end,
	},
}
