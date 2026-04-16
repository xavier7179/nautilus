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
}
