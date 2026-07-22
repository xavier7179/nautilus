return {
	{ "MunifTanjim/nui.nvim" },
	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- snacks.nvim owns vim.notify (see snacks.lua notifier config);
			-- don't let noice fight it for the hook, it only causes health-check nagging.
			notify = { enabled = false },
			-- The periodic health checker throws false-positive "overwritten" warnings
			-- (stale closures after noice re-enables, e.g. via snacks zen mode toggle).
			health = { checker = false },
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		-- Both noice and snacks notifier are kept active:
		-- noice handles LSP hover/signature UI + message routing (<leader>sn* keymaps)
		-- snacks handles notification history/dismiss (<leader>n, <leader>un)
		keys = {
			{
				"<leader>sn",
				"",
				desc = "+noice",
			},
			{
				"<leader>snl",
				function() require("noice").cmd("last") end,
				desc = "Noice Last Message",
			},
			{
				"<leader>snh",
				function() require("noice").cmd("history") end,
				desc = "Noice History",
			},
			{
				"<leader>sna",
				function() require("noice").cmd("all") end,
				desc = "Noice All",
			},
			{
				"<leader>snd",
				function() require("noice").cmd("dismiss") end,
				desc = "Dismiss All",
			},
			{
				"<c-f>",
				function()
					if not require("noice.lsp").scroll(4) then return "<c-f>" end
				end,
				silent = true,
				expr = true,
				desc = "Scroll Forward",
				mode = { "i", "n", "s" },
			},
			{
				"<c-b>",
				function()
					if not require("noice.lsp").scroll(-4) then return "<c-b>" end
				end,
				silent = true,
				expr = true,
				desc = "Scroll Backward",
				mode = { "i", "n", "s" },
			},
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then vim.cmd([[messages clear]]) end
			require("noice").setup(opts)
		end,
	},
}
