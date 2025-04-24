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

-- Colorscheme functions
--
---@param fallback? string
---@return string|nil
_G.get_colorscheme = function(fallback)
    if not vim.g.COLORS_NAME then
        vim.cmd.rshada()
    end
    return vim.g.COLORS_NAME or fallback
end

---@param colorscheme? string
_G.save_colorscheme = function(colorscheme)
    colorscheme = colorscheme or vim.g.colors_name
    if get_colorscheme() == colorscheme then
        return
    end
    vim.g.COLORS_NAME = colorscheme
    vim.cmd.wshada()
end

require("lazy").setup({
    spec = {
        { import = "nautilus.plugins" },      -- common plugins
        { import = "nautilus.plugins.lang" }, -- language related plugins
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
        colorscheme = { get_colorscheme("default") },
    },
})
