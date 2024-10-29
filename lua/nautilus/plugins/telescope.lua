return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"folke/todo-comments.nvim",
		},
		config = function()
			-- File Search setup (Telescope)
			local builtin = require("telescope.builtin")

			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
			})

			-- Live Grep (<leader>fg)
			require("telescope").load_extension("live_grep_args")

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
			keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
			keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Lists open buffers" })
			keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
			keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Lists available help tags" })
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				defaults = {},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
} -- Searching Files
