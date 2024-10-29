return {
	-- Focus plugins
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			on_open = function(_)
				vim.opt.nu = false
				vim.opt.relativenumber = false
				require("noice").disable()
				require("ufo").disable()
				vim.o.foldcolumn = "0"
				vim.o.foldenable = false
			end,
			on_close = function()
				vim.opt.nu = true
				vim.opt.relativenumber = true
				require("noice").enable()
				require("ufo").enable()
				vim.o.foldcolumn = "1"
				vim.o.foldenable = true
			end,
		},
		config = function()
			local keymap = vim.keymap
			keymap.set("n", "<leader>zm", "<cmd>ZenMode<CR>", { desc = "Activate Zen Mode" })

			require("zen-mode").setup({
				window = {
					backdrop = 0.95,
					width = 120, -- width of the Zen window
					height = 1, -- height of the Zen window
					options = {
						signcolumn = "no", -- disable signcolumn
						number = false, -- disable number column
						relativenumber = false, -- disable relative numbers
						-- cursorline = false, -- disable cursorline
						-- cursorcolumn = false, -- disable cursor column
						-- foldcolumn = "0", -- disable fold column
						-- list = false, -- disable whitespace characters
					},
				},
				plugins = {
					-- disable some global vim options (vim.o...)
					options = {
						enabled = true,
						ruler = true, -- disables the ruler text in the cmd line area
						showcmd = false, -- disables the command in the last line of the screen
						-- you may turn on/off statusline in zen mode by setting 'laststatus'
						-- statusline will be shown only if 'laststatus' == 3
						laststatus = 0, -- turn off the statusline in zen mode
					},
					twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
					gitsigns = { enabled = false }, -- disables git signs
					tmux = { enabled = true }, -- disables the tmux statusline
					wezterm = {
						enabled = true,
						font = "+20", -- (10% increase per step)
					},
				},
			})
		end,
	},
	{
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
