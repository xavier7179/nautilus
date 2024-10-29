-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "nautilus.plugins" },
	{ import = "nautilus.plugins.git" },
	{ import = "nautilus.plugins.cmake" },
	{ import = "nautilus.after.ftplugins" },
}, {
	-- Enable automatic checks for update but without notification
	checker = {
		enabled = true,
		notify = false,
	},
	-- Stop notification of config updates
	change_detection = {
		notify = false,
	},
})
