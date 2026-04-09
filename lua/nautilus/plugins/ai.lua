return {

	-- Copilot backend
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				["*"] = true,
			},
		},
		config = function(_, opts) require("copilot").setup(opts) end,
	},

	-- CodeCompanion: light AI assistant (chat + edits)
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		opts = {
			adapters = {
				copilot = {
					-- CodeCompanion has built-in support for Copilot and GitHub Models [web:28][web:290]
					enabled = true,
				},
			},
			strategies = {
				chat = { adapter = "copilot" },
				inline = { adapter = "copilot" },
			},
			-- we’ll keep defaults for now and refine prompts later
		},
		keys = {
			{
				"<leader>ac",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "Toggle Chat",
				mode = { "n", "v" },
			},
			{
				"<leader>ao",
				"<cmd>CodeCompanionActions<cr>",
				desc = "Options",
				mode = { "n", "v" },
			},
		},
		config = function(_, opts)
			local cc = require("codecompanion")
			cc.setup(opts)

			-- set a filetype for codecompanion chats (so that edgy sees them)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "codecompanion", "codecompanion-chat" },
				callback = function() vim.bo.filetype = "codecompanion_chat" end,
			})
		end,
	},
}
