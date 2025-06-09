-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local core = require("nautilus.core.functions")

require("lazy").setup({
	spec = {
		{ import = "nautilus.plugins" }, -- common plugins
		{ import = "nautilus.plugins.ui" }, -- user interface related plugins
		{ import = "nautilus.plugins.lang" }, -- language related plugins
		{ import = "nautilus.plugins.utils" }, -- utility plugins
	},
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
	install = {
		-- Set the colorscheme for the `:Lazy` UI
		colorscheme = { core.getColorscheme("default") },
	},
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
