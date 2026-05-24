return require("nautilus.custom.colorscheme").lazy_setup({
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "moon",
			terminal_colors = true,
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				diffview = true,
				dropbar = { enabled = true, color_mode = true },
				flash = true,
				gitsigns = true,
				grug_far = true,
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
				neotest = true,
				neotree = false,
				noice = true,
				overseer = true,
				snacks = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			variant = "auto",
			dark_variant = "main",
			disable_background = false,
			disable_float_background = false,
			dim_inactive_windows = false,
			extend_background_behind_borders = true,
			styles = {
				transparency = false,
				bold = true,
				italic = false,
			},
		},
	},

	{
		"olimorris/onedarkpro.nvim",
		opts = {
			filetypes = {
				go = false,
				ruby = false,
				java = false,
				vue = false,
			},
			plugins = {
				all = false,
				blink_cmp = true,
				codecompanion = true,
				flash_nvim = true,
				gitsigns = true,
				mason = true,
				mini_diff = true,
				mini_icons = true,
				neotest = true,
				nvim_dap = true,
				nvim_dap_ui = true,
				nvim_lsp = true,
				snacks = true,
				trouble = true,
				which_key = true,
			},
		},
	},
	{
		"Mofiqul/dracula.nvim",
		opts = {
			transparent_bg = false,
			italic_comment = true,
		},
	},
	{ "shaunsingh/nord.nvim" },
	{
		"vimcolorschemes/olive-crt.nvim",
		opts = {},
	},
	{
		"embark-theme/vim",
		name = "embark",
	},
	{
		"sainnhe/gruvbox-material",
		init = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_enable_italic = 0
			vim.g.gruvbox_material_transparent_background = 0
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		opts = {
			filter = "machine",
			transparent_background = false,
			terminal_colors = true,
		},
	},
	{
		"rmehri01/onenord.nvim",
		opts = {
			theme = "dark",
			disable = {
				background = false,
				float_background = false,
			},
		},
	},
	{
		"everviolet/nvim",
		name = "evergarden",
		opts = {
			editor = {
				transparent_background = false,
				sign = { color = "none" },
				float = {
					color = "mantle",
					solid_border = false,
				},
				completion = {
					color = "surface0",
				},
			},
			integrations = {
				blink_cmp = true,
				cmp = false,
				fzf_lua = false,
				gitsigns = true,
				indent_blankline = { enable = true, scope_color = "green" },
				mini = {
					enable = true,
					animate = true,
					clue = true,
					completion = true,
					cursorword = true,
					deps = true,
					diff = true,
					files = true,
					hipatterns = true,
					icons = true,
					indentscope = true,
					jump = true,
					jump2d = true,
					map = true,
					notify = true,
					operators = true,
					pick = true,
					starters = true,
					statusline = true,
					surround = true,
					tabline = true,
					test = true,
					trailspace = true,
				},
				nvimtree = false,
				rainbow_delimiters = true,
				symbols_outline = true,
				telescope = false,
				which_key = true,
				neotree = false,
			},
		},
	},
	{
		"zootedb0t/citruszest.nvim",
	},
	{
		"mushanyoung/vim-windflower",
	},
	{
		"titanzero/zephyrium",
	},
	{
		"Mofiqul/adwaita.nvim",
	},
	{
		"maxmx03/fluoromachine.nvim",

		opts = {
			theme = "retrowave",
			glow = true,
			transparent = false,
		},
	},
	{
		"ptdewey/darkearth-nvim",
	},
	{
		"dgrco/deepwater.nvim",
	},
})
