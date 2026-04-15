local lang = require("nautilus.custom.lang")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- event = { "BufReadPre", "BufNewFile" },
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		opts = {
			-- auto_install = true,
			ensure_installed = vim.list_extend(lang.treesitter(), {
				"dockerfile",
				"git_config",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"git_rebase",
				"json",
				"json5",
				"jsonc",
				"toml",
				"xml",
			}),
			-- List of parsers to ignore installing (or "all")
			ignore_install = {},
			--sync_install = false,
			-- enable syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
			-- enable indentation
			indent = { enable = true, disable = { "markdown" } },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- incremental selection using control space
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
	},
} -- Synthax Highlighting
