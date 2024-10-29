return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
			},
		})
		local map = vim.keymap.set

		map("n", "<leader>fe", "<cmd>Neotree filesystem reveal left<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		map("n", "<leader>fc", "<cmd>Neotree show<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		-- TODO: find the proper mapping
		-- map("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		-- map("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
} -- File System Browser
