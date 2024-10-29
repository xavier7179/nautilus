vim.g.mapleader = " "

local keymap = vim.keymap

-- Disable arrows movement
keymap.set("", "<Up>", "<Nop>")
keymap.set("", "<Down>", "<Nop>")
keymap.set("", "<Left>", "<Nop>")
keymap.set("", "<Right>", "<Nop>")

-- The next four lines define key mappings for switching between windows using Ctrl + hjkl keys
keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true })
keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true })
keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true })
keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true })

-- The next four lines define key mappings for resizing windows using Alt + hjkl keys
keymap.set("n", "<A-l>", ":vertical resize -5<CR>", { silent = true })
keymap.set("n", "<A-h>", ":vertical resize +5<CR>", { silent = true })
keymap.set("n", "<A-j>", ":resize -5<CR>", { silent = true })
keymap.set("n", "<A-k>", ":resize +5<CR>", { silent = true })

-- These lines define key mappings for moving the cursor 10 spaces at a time using Shift + arrow keys
keymap.set("n", "<S-l>", "10l", { silent = true })
keymap.set("n", "<S-h>", "10h", { silent = true })
keymap.set("n", "<S-j>", "10j", { silent = true })
keymap.set("n", "<S-k>", "10k", { silent = true })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- new file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- buffers
keymap.set("n", "<leader>bh", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>bl", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
--keymap.set("n", "<leader>bd", LazyVim.ui.bufremove, { desc = "Delete Buffer" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
