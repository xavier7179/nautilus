return {
	{
		"folke/edgy.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			opts = opts or {}

			-- Left: Snacks explorer
			opts.left = opts.left or {}
			table.insert(opts.left, {
				ft = "snacks_explorer", -- Snacks explorer filetype
				title = "Explorer",
				size = { width = 30 },
			})

			-- Right: AI chat + DAP UI
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "codecompanion_chat",
				title = "AI Chat",
				size = { height = 0.4 },
			})
			--table.insert(opts.right, {
			--	ft = "dapui_scopes",
			--	title = "Scopes",
			--	size = { height = 0.2 },
			--})
			--table.insert(opts.right, {
			--	ft = "dapui_watches",
			--	title = "Watches",
			--	size = { height = 0.2 },
			--})
			--table.insert(opts.right, {
			--	ft = "dapui_stacks",
			--	title = "Stacks",
			--	size = { height = 0.2 },
			--})
			--table.insert(opts.right, {
			--	ft = "dapui_breakpoints",
			--	title = "Breakpoints",
			--})

			-- Bottom: terminals + quickfix
			opts.bottom = opts.bottom or {}
			table.insert(opts.bottom, {
				ft = "snacks_terminal",
				title = "Terminal",
				size = { height = 12 },
			})
			table.insert(opts.bottom, {
				ft = "qf",
				title = "Quickfix",
				size = { height = 8 },
			})

			return opts
		end,
	},
}
