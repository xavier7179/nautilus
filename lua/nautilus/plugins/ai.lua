return {
	"zbirenbaum/copilot.lua", -- for providers='copilot'
	{ -- Copilot Chat
		"CopilotC-Nvim/CopilotChat.nvim",
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		keys = {
			-- lazy.nvim keys
			{ "<leader>ac", "", desc = "+CopilotChat", mode = { "n", "v" } },
			{
				"<leader>act",
				function() return require("CopilotChat").toggle() end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
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
			input = {
				provider = "snacks", -- "native" | "dressing" | "snacks"
				provider_opts = {
					-- Snacks input configuration
					title = "Avante Input",
					icon = " ",
				},
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
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
					selector = {
						provider = "snacks",
						-- Options override for custom providers
						provider_opts = {},
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
		-- Replace event with keys for lazy-loading
		keys = {
			{ "<leader>av", "", desc = "+Avante", mode = { "n", "v" } },
			{
				"<leader>avp",
				function() return require("avante.api").ask() end,
				desc = "Prompt (Avante)",
				mode = { "n", "v" },
			},
			{
				"<leader>avt",
				function() return require("avante.api").toggle() end,
				desc = "Toggle (Avante)",
				mode = { "n", "v" },
			},
		},
	},
	-- Edgy integration
	-- TODO: edgy integration should have a space but shared among ai windows
	-- {
	-- 	"folke/edgy.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		opts.right = opts.right or {}
	-- 		table.insert(opts.right, {
	-- 			ft = "copilot-chat",
	-- 			title = "Copilot Chat",
	-- 			size = { width = 50 },
	-- 		})
	-- 		table.insert(opts.right, {
	-- 			ft = "Avante",
	-- 			title = "Avante",
	-- 			size = { width = 50 },
	-- 		})
	-- 	end,
	-- },
}
