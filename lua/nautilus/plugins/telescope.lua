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

			keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]uzzy [F]ind files in cwd" })
			keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep string in cwd" })
			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]uzzy find [R]ecent files" })
			keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind open [B]uffers" })
			keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind string under [C]ursor in cwd" })
			keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind available [H]elp tags" })
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
			keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[F]ind [K]eymaps" })
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
