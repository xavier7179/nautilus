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
}
