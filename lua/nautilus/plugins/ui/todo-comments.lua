return {
	{ -- TODO comments navigations
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "TodoTrouble" },
		opts = {
			--signs = false
		},
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
        },
	},
}
