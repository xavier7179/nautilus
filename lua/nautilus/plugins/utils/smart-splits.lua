return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		dependencies = {
			{
				"smart-splits-nvim/backend-wezterm",
				opts = {
					-- Used by the backend's health check; the integration itself
					-- communicates through WezTerm user variables.
					cli_path = "wezterm",
				},
			},
		},
		opts = function()
			local is_wezterm = vim.env.TERM_PROGRAM == "WezTerm"
			local legacy_backend = is_wezterm and "wezterm" or nil
			local ignored_buftypes = { "nofile", "quickfix", "prompt" }
			local ignored_filetypes = { "NvimTree", "neo-tree", "snacks_picker_list" }

			-- smart-splits v3 moved these options into feature namespaces. Detect the
			-- schema instead of relying on a plugin version, so older lockfiles keep
			-- working without making v3 report the legacy keys as config problems.
			local ok, config = pcall(require, "smart-splits.config")
			local has_namespaced_options = ok
				and type(config.mux) == "table"
				and type(config.resize) == "table"
				and type(config.move) == "table"

			if has_namespaced_options then
				return {
					mux = {
						backend = is_wezterm and "smart-splits-backend-wezterm" or nil,
					},
					-- Do nothing at the edge (avoids accidental WezTerm pane creation).
					move = {
						at_edge = "stop",
						ignored_buftypes = ignored_buftypes,
						ignored_filetypes = ignored_filetypes,
					},
					-- Match the previous manual resize step of 5.
					resize = {
						amount = 5,
						ignored_buftypes = ignored_buftypes,
						ignored_filetypes = ignored_filetypes,
					},
				}
			end

			-- Compatibility with smart-splits versions before the namespaced schema.
			return {
				multiplexer_integration = legacy_backend,
				at_edge = "stop",
				default_amount = 5,
				ignored_buftypes = ignored_buftypes,
				ignored_filetypes = ignored_filetypes,
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
