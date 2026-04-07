return {
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

	{
		"yetone/avante.nvim",
		version = false,
		build = "make",
		keys = {
			{ "<leader>a", "", desc = "+AI", mode = { "n", "v" } },
			{
				"<leader>at",
				function() require("avante.api").toggle() end,
				desc = "Toggle Avante",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function() require("avante.api").ask() end,
				desc = "Prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>af",
				function()
					require("avante.api").ask({
						prompt = "Fix the current problem with the smallest safe change. Explain the reason briefly before editing.",
					})
				end,
				desc = "Fix current problem",
				mode = { "n", "v" },
			},
			{
				"<leader>ar",
				function()
					require("avante.api").ask({
						prompt = "Refactor the selected code without changing behavior. Prefer readability and maintainability.",
					})
				end,
				desc = "Refactor selection",
				mode = { "n", "v" },
			},
			{
				"<leader>ae",
				function()
					require("avante.api").ask({
						prompt = "Explain the current error or diagnostic in project context and suggest the next debugging step.",
					})
				end,
				desc = "Explain diagnostic",
				mode = { "n", "v" },
			},
			{
				"<leader>ac",
				function()
					local api = require("avante.api")
					local buf = vim.api.nvim_get_current_buf()
					local last = vim.api.nvim_buf_line_count(buf)
					api.ask({
						range = { 1, 0, last, 0 },
						prompt = "Review this file for correctness, maintainability, and likely bugs. Suggest minimal high-value improvements.",
					})
				end,
				desc = "Review current file",
				mode = { "n" },
			},
			{
				"<leader>ai",
				function()
					require("avante.api").ask({
						prompt = "Create an implementation plan only. Do not write code yet. Break the work into concrete steps.",
					})
				end,
				desc = "Implementation plan",
				mode = { "n", "v" },
			},
			{
				"<leader>as",
				function()
					require("avante.api").ask({
						prompt = "Generate or improve tests for the selected code. Focus on realistic edge cases.",
					})
				end,
				desc = "Generate tests",
				mode = { "n", "v" },
			},
		},
		opts = {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
			input = {
				provider = "snacks",
				provider_opts = {
					title = "Avante Input",
					icon = " ",
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "Avante",
				callback = function(args)
					pcall(vim.treesitter.stop, args.buf)
					vim.bo[args.buf].syntax = "off"
					vim.wo.conceallevel = 0
				end,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
					selector = {
						provider = "snacks",
						provider_opts = {},
					},
				},
			},
			--			{
			--				"MeanderingProgrammer/render-markdown.nvim",
			--				optional = true,
			--				opts = {
			--					file_types = { "markdown", "Avante" },
			--				},
			--				ft = { "markdown", "Avante" },
			--			},
		},
	},
}
