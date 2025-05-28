local core = require("nautilus.core.functions")
-- Create a FormatDisable command
vim.api.nvim_create_user_command("FormatDisable", core.disableAutoFormatting, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", core.enableAutoFormatting, {
    desc = "Re-enable autoformat-on-save",
})
