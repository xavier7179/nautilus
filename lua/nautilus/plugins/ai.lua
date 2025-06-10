return {

	"zbirenbaum/copilot.lua", -- for providers='copilot'
	{ -- Copilot Chat
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		-- dependencies = {
		--    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		--  { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
		-- },
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		keys = {
			-- lazy.nvim keys
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ac",
				"",
				desc = "+CopilotChat",
				mode = { "n", "v" },
			},
			{
				"<leader>act",
				function() return require("CopilotChat").toggle() end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Show help actions with telescope
			--{
			--	"<leader>ach",
			--	function()
			--		local actions = require("CopilotChat.actions")
			--		require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			--	end,
			--	desc = "CopilotChat - Help actions",
			--},
			-- Show prompts actions with telescope
			-- {
			-- 	"<leader>acp",
			-- 	function()
			-- 		local actions = require("CopilotChat.actions")
			-- 		require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			-- 	end,
			-- 	desc = "CopilotChat - Prompt actions",
			-- },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then vim.bo.filetype = "markdown" end
				end,
			})

			chat.setup(opts)
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
			copilot = {
				model = "claude-3.7-sonnet",
			},
			openai = {
				endpoint = "https://api.githubcopilot.com",
				model = "", -- il tuo modello desiderato (o usa gpt-4o, ecc.)
				timeout = 30000, -- timeout in millisecondi
				temperature = 0, -- aggiusta se necessario
				max_tokens = 4096,
				-- reasoning_effort = "high" -- supportato solo per modelli di ragionamento (o1, ecc.)
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			--   "nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim", -- TODO: hopefully new versions will integrate with Snacks.nvim
			--   "nvim-lua/plenary.nvim",
			--           "MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			-- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			-- "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			--           "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
			-- "zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				optional = true,
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	-- Edgy integration
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "copilot-chat",
				title = "Copilot Chat",
				size = { width = 50 },
			})
			table.insert(opts.right, {
				ft = "Avante",
				title = "Avante",
				size = { width = 50 },
			})
		end,
	},
}
