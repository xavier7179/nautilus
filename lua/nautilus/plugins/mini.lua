return {
	{
		"echasnovski/mini.splitjoin",
		version = false,
		config = function()
			local miniSJ = require("mini.splitjoin")
			miniSJ.setup({
				mappings = { toggle = "" }, -- Disable default mappings
			})
			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSJ.join()
			end, { desc = "Join Arguments" })
			vim.keymap.set({ "n", "x" }, "ss", function()
				miniSJ.split()
			end, { desc = "Split Arguments" })
		end,
	},
	{ "echasnovski/mini.icons", version = false }, -- mini icons required by many plugins
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
	{ "echasnovski/mini.surround", version = false },
}
