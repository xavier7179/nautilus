local prompts = require("nautilus.custom.prompts")

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
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		opts = {
			adapters = {
				copilot = {
					enabled = true,
				},
			},
			strategies = {
				chat = { adapter = "copilot" },
				inline = { adapter = "copilot" },
			},
			prompt_library = vim.tbl_deep_extend("keep", prompts.get_entries(), {}),
			interactions = {
				chat = {
					tools = {
						groups = {
							debug_agent = {
								description = "Debug: tools for hypothesis-instrument workflow",
								tools = {
									"ask_questions",
									"create_file",
									"delete_file",
									"file_search",
									"get_changed_files",
									"get_diagnostics",
									"grep_search",
									"insert_edit_into_file",
									"read_file",
									"run_command",
								},
								opts = {
									collapse_tools = true,
									ignore_system_prompt = true,
									ignore_tool_system_prompt = true,
								},
							},
							read = {
								description = "Read-only tools for code review and analysis",
								tools = {
									"file_search",
									"grep_search",
									"read_file",
									"get_diagnostics",
									"get_changed_files",
								},
								opts = {
									collapse_tools = true,
								},
							},
						},
					},
				},
			},
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
			{
				"<leader>aa",
				function() prompts.pick() end,
				desc = "Agents: Select Agent",
			},
		},
		config = function(_, opts)
			local cc = require("codecompanion")
			cc.setup(opts)

			-- Normalize codecompanion filetypes to a single ft for consistent keymap/Trouble targeting.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "codecompanion", "codecompanion-chat" },
				callback = function() vim.bo.filetype = "codecompanion_chat" end,
			})
		end,
	},
}
