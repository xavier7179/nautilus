return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		dependencies = {
			"windwp/nvim-ts-autotag", -- auto-tag closure support
		},
		opts = {
			auto_install = true,
			ensure_installed = {
				-- shell / config
				"bash",
				"cmake",
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
				"yaml",

				-- lua / nvim
				"lua",
				"luadoc",
				"luap",
				"printf",
				"query",
				"vim",
				"vimdoc",

				-- web / js / ts
				"css",
				"html",
				"javascript",
				"jsdoc",
				"tsx",
				"typescript",
				"xml",

				-- systems / native
				"c",
				"cpp",
				"diff",
				"rust",
				"ron",

				-- writing / docs
				"comment",
				"markdown",
				"markdown_inline",
				"regex",

				-- other supported languages
				"php",
			},
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
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},
} -- Synthax Highlighting
