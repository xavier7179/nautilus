return {
	-- Split join (gS to toggle)
	{ "echasnovski/mini.splitjoin", version = "*", opts = {} },
	{ "echasnovski/mini.icons", version = "*" }, -- mini icons required by many plugins
	-- Better Around/Inside textobjects
	--
	-- Examples:
	--  - va)  - [V]isually select [A]round [)]paren
	--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
	--  - ci'  - [C]hange [I]nside [']quote
	{ "echasnovski/mini.ai", opts = { n_lines = 500 } },
	-- Add/delete/replace surroundings (brackets, quotes, etc.)
	--
	-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
	-- - sd'   - [S]urround [D]elete [']quotes
	-- - sr)'  - [S]urround [R]eplace [)] [']
	{ "echasnovski/mini.surround", version = "*", opts = {} },
	{
		"echasnovski/mini.tabline",
		version = "*",
		opts = {
			format = function(buf_id, label)
				local suffix = vim.bo[buf_id].modified and " " or ""
				return MiniTabline.default_format(buf_id, label) .. suffix
			end,
		},
	},
	{ "echasnovski/mini.pairs", version = "*", event = { "InsertEnter" }, opts = {} },
}
