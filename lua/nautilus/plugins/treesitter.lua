local lang = require("nautilus.custom.lang")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
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
			-- NOTE: incremental selection is no longer a module here; nvim 0.12+
			-- provides it natively via the `an`/`in` node textobjects, see
			-- nautilus.core.keymaps
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
	{
		"windwp/nvim-ts-autotag",
		-- No ft filter here: internal.lua's attach() already no-ops via
		-- TagConfigs:get(vim.bo.filetype), so the plugin is the source of truth
		-- for which filetypes it supports, not a list we'd have to keep in sync.
		event = { "BufReadPost", "BufNewFile" },
		-- nested under opts.opts: current nvim-ts-autotag setup() layout, not a typo
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
		},
	},
} -- Synthax Highlighting
