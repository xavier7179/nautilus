-- dropbar.nvim — IDE-style breadcrumb bar (XCode / Rider parity)
-- Shows file path + current symbol context in the winbar.
-- `[b` / `]b` navigate context; `<leader>cB` opens the picker.
return {
	{
		"Bekaboo/dropbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		-- Requires nvim-0.10+ (winbar support is stable there)
		cond = function() return vim.fn.has("nvim-0.10") == 1 end,
		dependencies = {},
		keys = {
			{
				"<leader>cB",
				function() require("dropbar.api").pick() end,
				desc = "[C]ode [B]readcrumb picker",
			},
			{
				"[b",
				function() require("dropbar.api").goto_context_start() end,
				desc = "Go to breadcrumb context start",
			},
			{
				"]b",
				function() require("dropbar.api").select_next_context() end,
				desc = "Select next breadcrumb context",
			},
		},
		opts = {
			icons = {
				enable = true,
				ui = {
					bar = {
						separator = "  ",
						extends = "…",
					},
					menu = {
						separator = " ",
						indicator = " ",
					},
				},
			},
			bar = {
				-- Show dropbar in normal file buffers and help pages; hide in
				-- special/floating windows to keep them clean.
				enable = function(buf, win, _)
					if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
						return false
					end
					if vim.api.nvim_win_get_config(win).zindex then return false end -- floating
					local bt = vim.bo[buf].buftype
					local ft = vim.bo[buf].filetype
					local excluded_bt = { "terminal", "quickfix", "nofile", "prompt" }
					local excluded_ft = { "neo-tree", "Trouble", "lazy", "mason", "toggleterm" }
					if vim.tbl_contains(excluded_bt, bt) then return false end
					if vim.tbl_contains(excluded_ft, ft) then return false end
					return true
				end,
			},
		},
	},
}
