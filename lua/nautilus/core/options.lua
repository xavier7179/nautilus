-- My Editing preferences
--
local opt = vim.opt

-- c: Automatically break comments using the textwidth value.
-- r: Automatically insert the comment leader when hitting <Enter> in insert mode.
-- o: Automatically insert the comment leader when hitting 'o' or 'O' in normal mode.
-- n: Recognize numbered lists. When hitting <Enter> in insert mode.
-- m: Automatically break the current line before inserting a new comment line.
opt.formatoptions:append("cronm")
opt.relativenumber = true -- show relative line numbers
opt.number = true -- displays line numbers in the left margin.
opt.tabstop = 4 -- spaces for tab
opt.softtabstop = 4
opt.shiftwidth = 4 -- spaces for indent width
opt.expandtab = true -- expand tab spaces
opt.autoindent = true -- copy indent from current line when starting a new one

opt.backup = false --  This disables the creation of backup files.
opt.swapfile = false -- This disables the creation of swap files.
opt.autoread = true -- Automatically reload files when they changed

-- Enable spell check
opt.spell = true
opt.spelllang = "en_us,it"
opt.cursorline = true -- Highlight the current line
-- opt.list = true -- Show white space characters and tab characters

opt.termguicolors = true -- turn on termguicolors for all colorschemes that supports colors
opt.background = "dark" -- colorschemes that can be light or dark will be forced to dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
