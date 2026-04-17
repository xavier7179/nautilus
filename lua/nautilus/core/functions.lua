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
	if not vim.g.COLORS_NAME then vim.cmd.rshada() end
	if not vim.g.COLORS_NAME or vim.g.COLORS_NAME == "" then return fallback or "default" end
	return vim.g.COLORS_NAME
end

---@param colorscheme? string
M.saveColorscheme = function(colorscheme)
	colorscheme = colorscheme or vim.g.colors_name
	if M.getColorscheme() == colorscheme then return end
	vim.g.COLORS_NAME = colorscheme
	vim.cmd.wshada()
end

M.closePickersByLayout = function(active_pickers, layout_name, picker_to_avoid)
	-- Iterate through each active picker
	for _, picker in ipairs(active_pickers) do
		-- Check if the picker layout matches the specified layout and it is not the one to avoid
		if picker.layout == layout_name and picker ~= picker_to_avoid then
			-- Close the picker
			picker:close()
		end
	end
end

-- TODO: replace the function with a proper project plugin that makes possible to determine the root of the tree
M.get_file_with_path = function(bufnr, file)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local dir = bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h") or vim.fn.getcwd()
	return dir .. "/" .. file
end

return M
