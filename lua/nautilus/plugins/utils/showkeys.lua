local recording_active = false

return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	opts = {
		timeout = 1,
		maxkeys = 5,
	},
	keys = {
		{
			"<leader>uK",
			function()
				recording_active = not recording_active
				vim.cmd("ShowkeysToggle")
				-- Notify WezTerm via OSC 1337 SetUserVar so it can adjust font size.
				-- Value must be base64-encoded. "1" = recording on, "0" = recording off.
				local value = recording_active and "1" or "0"
				local encoded = vim.base64.encode(value)
				io.write(("\x1b]1337;SetUserVar=NVIM_RECORDING=%s\x07"):format(encoded))
				io.flush()
			end,
			desc = "Toggle recording mode (showkeys + font zoom)",
		},
	},
}
