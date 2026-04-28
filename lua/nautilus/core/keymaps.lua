local keymap = vim.keymap

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation  (Ctrl + hjkl) and resize (Alt + hjkl) are handled by
-- smart-splits.nvim (plugins/utils/smart-splits.lua) for seamless WezTerm integration.

-- Jump 10 lines at a time (Shift + jk)
keymap.set("n", "<S-j>", "10j", { silent = true })
keymap.set("n", "<S-k>", "10k", { silent = true })

-- ─── <leader>w  Window / Workspace ───────────────────────────────────────────

-- Window splits
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize splits" })
keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab management  (all under <leader>w to keep the tree clean)
keymap.set("n", "<leader>wo", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>wq", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>wn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>wp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>wt", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- ─── <leader>f  File ─────────────────────────────────────────────────────────

keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- ─── <leader>b  Buffer ───────────────────────────────────────────────────────

keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
