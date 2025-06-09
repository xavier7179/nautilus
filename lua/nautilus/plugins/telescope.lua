return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-live-grep-args.nvim",
			"folke/todo-comments.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			-- File Search setup (Telescope)
			local builtin = require("telescope.builtin")

			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					--    mappings = {
					--        i = {
					--            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
					--            ["<C-j>"] = actions.move_selection_next,     -- move to next result
					--            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					--        },
					--    },
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "live_grep_args")
			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]uzzy [F]ind files in cwd" })
			keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep string in cwd" })
			keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]uzzy find [R]ecent files" })
			keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind open [B]uffers" })
			keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind string under [C]ursor in cwd" })
			keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind available [H]elp tags" })
			keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		end,
	},
} -- Searching Files
