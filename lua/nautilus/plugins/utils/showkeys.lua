return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	opts = {
		timeout = 1,
		maxkeys = 5,
		-- more opts
	},
	keys = {
		{
			"<leader>uK",
			function()
				vim.cmd("ShowkeysToggle")
			end,
			desc = "Toggle Showkeys",
		},
	},
}
