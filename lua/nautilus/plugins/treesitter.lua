return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag", -- auto-tag closure support
		},
		config = function()
			-- Synthax Highlighting setup (TreeSitter)
			-- import nvim-treesitter plugin
			local configs = require("nvim-treesitter.configs")

			-- configure treesitter
			configs.setup({
				auto_install = false,
				ensure_installed = {
					"bash",
					"bibtex",
					"c",
					"cpp",
					"cmake",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"comment",
					"gitignore",
					"gitcommit",
					"json",
					"python",
					"javascript",
					"html",
					"cpp",
					"css", -- "doxygen",
					"regex",
					"ruby",
					"rust",
					"verilog",
					"yaml",
					"dockerfile",
					"markdown",
					"markdown_inline",
				},
				-- List of parsers to ignore installing (or "all")
				ignore_install = {},
				sync_install = false,
				-- enable syntax highlighting
				highlight = {
					enable = true,
					-- VimTex Integration
					disable = { "latex" },
					additional_vim_regex_highlighting = { "latex", "markdown" },
				},
				-- enable indentation
				indent = { enable = true },
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
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				max_lines = 5,
			})
		end,
	},
} -- Synthax Highlighting
