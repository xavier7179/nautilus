local core = require("nautilus.core.functions")
-- Create a FormatDisable command
vim.api.nvim_create_user_command("FormatDisable", core.disableAutoFormatting, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", core.enableAutoFormatting, {
    desc = "Re-enable autoformat-on-save",
})


-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
