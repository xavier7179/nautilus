return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>ue",
				function() require("edgy").toggle() end,
				desc = "Toggle Edgy panels",
			},
		},
		opts = function(_, opts)
			opts = opts or {}
			opts.options = opts.options or {}

			-- Bottom edgebar total height: terminal (10) + quickfix (5) + 1 border/padding.
			opts.options.bottom = { size = 16 }

			-- Right: AI chat + DAP UI panels.
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "codecompanion_chat",
				title = "AI Chat",
				size = { height = 0.4 },
			})
			table.insert(opts.right, {
				ft = "dapui_scopes",
				title = "Scopes",
				size = { height = 0.25 },
			})
			table.insert(opts.right, {
				ft = "dapui_watches",
				title = "Watches",
				size = { height = 0.25 },
			})
			table.insert(opts.right, {
				ft = "dapui_stacks",
				title = "Stacks",
				size = { height = 0.25 },
			})
			table.insert(opts.right, {
				ft = "dapui_breakpoints",
				title = "Breakpoints",
				size = { height = 0.25 },
			})

			-- Bottom: terminal (pinned, reuses last session) + quickfix.
			-- Absolute heights: terminal gets 10 lines, quickfix gets 5 lines.
			-- The official snacks terminal edgy integration requires a filter to match
			-- only bottom-position snacks terminal windows (not floating ones).
			opts.bottom = opts.bottom or {}
			table.insert(opts.bottom, {
				ft = "snacks_terminal",
				title = "Terminal",
				size = { height = 10 },
				pinned = true,
				open = function() Snacks.terminal.toggle() end,
				filter = function(_, win)
					return vim.w[win].snacks_win
						and vim.w[win].snacks_win.position == "bottom"
						and vim.w[win].snacks_win.relative == "editor"
				end,
			})
			table.insert(opts.bottom, {
				ft = "qf",
				title = "Quickfix",
				size = { height = 5 },
			})

			return opts
		end,
	},
}
