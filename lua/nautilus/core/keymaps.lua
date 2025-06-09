local keymap = vim.keymap

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

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
keymap.set("n", "<leader>Wv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
keymap.set("n", "<leader>Wh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>We", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
keymap.set("n", "<leader>Wx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })                     --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })                 --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- new file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- buffers
keymap.set("n", "<leader>bh", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>bl", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
