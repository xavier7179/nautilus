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

M.closePickersByLayout = function(active_pickers, layout_name, picker_to_avoid)
	-- Iterate through each active picker
	for _, picker in ipairs(active_pickers) do
		-- Check if the picker layout matches the specified layout and it is not the one to avoid
		if picker.opts.layout == layout_name and picker ~= picker_to_avoid then
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

M.feed_mapping = function(lhs)
	local keys = lhs:gsub("<leader>", vim.g.mapleader or "\\")
	local termcodes = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(termcodes, "m", false)
end

M.select_with_snacks = function(items, opts, on_choice)
	opts = opts or {}
	on_choice = on_choice or function() end

	if vim.tbl_isempty(items or {}) then
		local message = opts.empty_message or "No items available"
		vim.notify(message, vim.log.levels.WARN)
		return nil
	end

	local prompt = opts.prompt or "Select"
	local format_item = opts.format_item or function(item)
		if type(item) == "table" then return item.name or item.label or tostring(item.id or "") end
		return tostring(item)
	end

	return require("snacks").picker.select(items, {
		prompt = prompt,
		format_item = format_item,
	}, on_choice)
end

return M
