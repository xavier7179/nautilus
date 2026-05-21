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
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.treesitter.query.set(
				"markdown",
				"injections",
				[[
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)
((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))
((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))
((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))
([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
]]
			)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 4, -- max lines the context window can take up
			min_window_height = 20, -- only show when window is tall enough
			multiline_threshold = 1, -- max lines a single context can span
			trim_scope = "outer", -- which context lines to discard when max_lines is exceeded
			mode = "cursor", -- "cursor" or "topline"
			separator = nil, -- separator between context and content; nil = no line
		},
		keys = {
			{
				"[C",
				function() require("treesitter-context").go_to_context(vim.v.count1) end,
				desc = "Jump to outer context",
				silent = true,
			},
		},
	},
} -- Synthax Highlighting
