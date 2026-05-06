return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		opts = function()
			local is_wezterm = vim.env.TERM_PROGRAM == "WezTerm"
			return {
			multiplexer_integration = is_wezterm and "wezterm" or nil,
			-- Do nothing when cursor is already at the edge (avoids accidental WezTerm pane creation)
			at_edge = "stop",
			-- Match the previous manual resize step of 5
			default_amount = 5,
			ignored_buftypes = { "nofile", "quickfix", "prompt" },
			ignored_filetypes = { "NvimTree", "neo-tree", "snacks_picker_list" },
			}
		end,
		keys = {
			-- Window navigation (replaces raw :wincmd keymaps removed from keymaps.lua)
			{ "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split" },
			{ "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move to lower split" },
			{ "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move to upper split" },
			{ "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
			-- <A-hjkl> inside Neovim are handled by mini.move (line/selection movement).
			-- WezTerm intercepts <A-hjkl> only when IS_NVIM is false (non-Neovim pane resize).
			-- To resize Neovim splits use <leader>wr to enter resize mode (h/j/k/l + <Esc> to exit).
			{ "<leader>wr", function()
				local ss = require("smart-splits")
				local keys = {
					h = ss.resize_left,
					j = ss.resize_down,
					k = ss.resize_up,
					l = ss.resize_right,
				}

				local function exit()
					for key in pairs(keys) do
						pcall(vim.keymap.del, "n", key)
					end
					pcall(vim.keymap.del, "n", "<Esc>")
					pcall(vim.keymap.del, "n", "q")
					vim.notify("Resize mode OFF", vim.log.levels.INFO, { title = "Splits" })
				end

				for key, fn in pairs(keys) do
					vim.keymap.set("n", key, fn, { desc = "Resize " .. key, nowait = true })
				end
				vim.keymap.set("n", "<Esc>", exit, { desc = "Exit resize mode", nowait = true })
				vim.keymap.set("n", "q",     exit, { desc = "Exit resize mode", nowait = true })

				vim.notify("Resize mode  •  h/j/k/l to resize  •  <Esc> or q to exit", vim.log.levels.INFO, { title = "Splits" })
			end, desc = "Resize mode" },
		},
	},
}
