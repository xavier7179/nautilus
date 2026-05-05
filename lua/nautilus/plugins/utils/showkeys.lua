vim.g.nautilus_recording_mode = vim.g.nautilus_recording_mode or false

local function send_wezterm_user_var(name, value)
	if vim.env.TERM_PROGRAM ~= "WezTerm" then return end
	local encoded = vim.base64.encode(value)
	io.write(("\x1b]1337;SetUserVar=%s=%s\x07"):format(name, encoded))
	io.flush()
end

return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	init = function()
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = vim.api.nvim_create_augroup("NautilusShowkeysCleanup", { clear = true }),
			callback = function()
				if vim.g.nautilus_recording_mode then
					send_wezterm_user_var("NVIM_RECORDING", "0")
					vim.g.nautilus_recording_mode = false
				end
			end,
		})
	end,
	opts = {
		timeout = 1,
		maxkeys = 5,
	},
	keys = {
		{
			"<leader>uK",
			function()
				vim.g.nautilus_recording_mode = not vim.g.nautilus_recording_mode
				vim.cmd("ShowkeysToggle")
				local value = vim.g.nautilus_recording_mode and "1" or "0"
				send_wezterm_user_var("NVIM_RECORDING", value)
			end,
			desc = "Toggle recording mode (showkeys + font zoom)",
		},
	},
}
