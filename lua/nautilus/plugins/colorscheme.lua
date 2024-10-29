return {
	{
		"exosyphon/telescope-color-picker.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("colors")
			vim.keymap.set("n", "<leader>uC", "<cmd>Telescope colors<CR>", { desc = "Color Picker" })
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme onedark")
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme onelight")
			end,
		},
	},
} -- Color Scheme
