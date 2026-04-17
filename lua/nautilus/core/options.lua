-- Global Options

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Editing preferences
--
local opt = vim.opt

-- NOTE: the following line allow to map IT-based keys with the EN-base equivalent, this should help making less awkward moves
-- right now is limited to map:
-- è -> [
-- + -> ]
-- opt.langmap = "è+;[]" -- not working
--
-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history (across sessions)
vim.o.undofile = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

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

opt.backup = false -- This disables the creation of backup files.
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

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`-- clipboard
vim.schedule(function()
	vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

vim.cmd("filetype plugin on")
