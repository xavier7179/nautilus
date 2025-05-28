local M = {}

-- Auto Formatting Utilities
function M.disableAutoFormatting(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end

function M.enableAutoFormatting()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end

-- Colorscheme functions
--
---@param fallback? string
---@return string|nil
M.getColorscheme = function(fallback)
    print(vim.g.COLORS_NAME)
    if not vim.g.COLORS_NAME then
        vim.cmd.rshada()
    end
    if not vim.g.COLORS_NAME or vim.g.COLORS_NAME == '' then
        return fallback or 'default'
    end
    return vim.g.COLORS_NAME
end

---@param colorscheme? string
M.saveColorscheme = function(colorscheme)
    colorscheme = colorscheme or vim.g.colors_name
    print(colorscheme)
    if M.getColorscheme() == colorscheme then
        return
    end
    vim.g.COLORS_NAME = colorscheme
    vim.cmd.wshada()
end

return M
