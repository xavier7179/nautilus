return {
	{ -- persistent colorscheme saver
		"https://git.sr.ht/~swaits/colorsaver.nvim",
		lazy = true,
		event = "VimEnter",
		opts = {
			-- your options here
		},
		dependencies = {
			-- Kept for occasional use; commented out to avoid eager loading.
			-- { "EdenEast/nightfox.nvim" },
			-- { "AlexvZyl/nordic.nvim" },
			-- {
			-- 	"olimorris/onedarkpro.nvim",
			-- 	priority = 1000,
			-- 	pattern = { "onedark.*", "onelight", "vaporwave" },
			-- 	opts = {
			-- 		highlights = {
			-- 			Comment = { italic = true },
			-- 			Directory = { bold = true },
			-- 			ErrorMsg = { italic = true, bold = true },
			-- 		},
			-- 	},
			-- },
			{
				"folke/tokyonight.nvim",
				opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
			},
			{
				"catppuccin/nvim",
				name = "catppuccin",
				priority = 1000,
				opts = {
					integrations = {
						cmp = true,
						gitsigns = true,
						lsp_trouble = true,
						mason = true,
						markdown = true,
						mini = true,
						native_lsp = {
							enabled = true,
							underlines = {
								errors = { "undercurl" },
								hints = { "undercurl" },
								warnings = { "undercurl" },
								information = { "undercurl" },
							},
						},
						navic = { enabled = false },
						neotree = false,
						overseer = true,
						noice = true,
						snacks = true,
						telescope = true,
						treesitter = true,
						treesitter_context = true,
					},
				},
			},
		},
	},
	{ "MunifTanjim/nui.nvim" },
	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
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
				{ -- Skip notification of No Information Available type
					filter = { event = "notify", find = "No information available" },
					opts = { skip = true },
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
		-- TODO: check if keymaps are necessary or they can be integrated in snacks.nvim
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
