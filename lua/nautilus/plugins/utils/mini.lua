return {
	-- Split join (gS to toggle)
	{
		"echasnovski/mini.splitjoin",
		version = "*",
		opts = {},
		keys = {
			{ "gS", mode = { "n", "x" }, desc = "Toggle split/join" },
		},
	},
	{
		"echasnovski/mini.icons",
		event = "VeryLazy",
		version = "*",
	}, -- mini icons required by many plugins
	-- Better Around/Inside textobjects
	--
	-- Examples:
	--  - va)  - [V]isually select [A]round [)]paren
	--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
	--  - ci'  - [C]hange [I]nside [']quote
	{
		"echasnovski/mini.ai",
		version = "*",
		opts = { n_lines = 500 },
		keys = {
			{ "a", mode = { "o", "x" }, desc = "Around textobject" },
			{ "i", mode = { "o", "x" }, desc = "Inside textobject" },
		},
	},
	-- Add/delete/replace surroundings (brackets, quotes, etc.)
	--
	-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
	-- - sd'   - [S]urround [D]elete [']quotes
	-- - sr)'  - [S]urround [R]eplace [)] [']
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {},
		keys = {
			{ "sa", mode = { "n", "v" }, desc = "Add surround" },
			{ "sd", mode = "n", desc = "Delete surround" },
			{ "sr", mode = "n", desc = "Replace surround" },
			{ "sf", mode = "n", desc = "Find surround right" },
			{ "sF", mode = "n", desc = "Find surround left" },
			{ "sh", mode = "n", desc = "Highlight surround" },
			{ "sn", mode = "n", desc = "Update n_lines" },
		},
	},
	{
		"echasnovski/mini.tabline",
		event = "VeryLazy",
		version = "*",
		opts = {
			format = function(buf_id, label)
				local suffix = vim.bo[buf_id].modified and " " or ""
				return MiniTabline.default_format(buf_id, label) .. suffix
			end,
		},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		event = { "InsertEnter" },
		opts = {},
	},
	-- Move lines/selections with Alt+hjkl (normal + visual mode).
	-- <A-hjkl> are also bound to smart-splits resize, but WezTerm only intercepts
	-- those when IS_NVIM is false; inside Neovim these keys reach mini.move. No conflict.
	{
		"echasnovski/mini.move",
		version = "*",
		opts = {
			mappings = {
				left       = "<A-h>",
				right      = "<A-l>",
				down       = "<A-j>",
				up         = "<A-k>",
				line_left  = "<A-h>",
				line_right = "<A-l>",
				line_down  = "<A-j>",
				line_up    = "<A-k>",
			},
		},
		keys = {
			{ "<A-h>", mode = { "n", "v" }, desc = "Move selection left" },
			{ "<A-j>", mode = { "n", "v" }, desc = "Move selection down" },
			{ "<A-k>", mode = { "n", "v" }, desc = "Move selection up" },
			{ "<A-l>", mode = { "n", "v" }, desc = "Move selection right" },
		},
	},
	-- Minimap sidebar with git diff and diagnostic symbols.
	-- auto_open = false: only shows on explicit <leader>um toggle.
	{
		"echasnovski/mini.map",
		version = "*",
		keys = {
			{ "<leader>um", function() require("mini.map").toggle() end, desc = "Toggle minimap" },
		},
		opts = function()
			local map = require("mini.map")
			return {
				integrations = {
					map.gen_integration.gitsigns(),
					map.gen_integration.diagnostic(),
				},
				symbols = { encode = map.gen_encode_symbols.dot("4x2") },
				window  = { auto_open = false, width = 10 },
			}
		end,
	},
	-- Highlight trailing whitespace and trim it automatically on save.
	-- markdownlint-cli2 already enforces MD009 (no trailing spaces) so markdown is safe.
	{
		"echasnovski/mini.trailspace",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },
		init = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("MiniTrailspaceTrim", { clear = true }),
				callback = function() require("mini.trailspace").trim() end,
			})
		end,
		keys = {
			{ "<leader>uW", function() require("mini.trailspace").trim() end, desc = "Trim trailing whitespace" },
		},
		opts = {},
	},
	-- Comment toggling with Treesitter-aware commentstring (TSX, JSX, Svelte, HTML).
	-- Replaces the commented-out Comment.nvim that was removed from editing.lua.
	{
		"echasnovski/mini.comment",
		version = "*",
		keys = {
			{ "gc",  mode = { "n", "v" }, desc = "Toggle comment" },
			{ "gcc", mode = "n",          desc = "Toggle comment line" },
		},
		opts = {
			options = {
			custom_commentstring = function()
				local ok, cs = pcall(function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
				end)
				return (ok and cs) or vim.bo.commentstring
			end,
			},
		},
	},
}
