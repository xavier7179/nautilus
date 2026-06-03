local M = {}

function M.buf_dir(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then return vim.fn.getcwd() end
	return vim.fn.fnamemodify(path, ":p:h")
end

function M.matches_project_markers(project_scope, bufnr)
	if not project_scope then return true end
	local markers = project_scope.markers or {}
	if vim.tbl_isempty(markers) then return true end

	local start = M.buf_dir(bufnr)
	for _, marker in ipairs(markers) do
		local found = vim.fn.findfile(marker, start .. ";")
		if found == "" then found = vim.fn.finddir(marker, start .. ";") end
		if found ~= "" then return true end
	end

	return false
end

function M.matches_scope(scope, bufnr, language_for_ft)
	if not scope or vim.tbl_isempty(scope) then return true end

	local ft = vim.bo[bufnr].filetype
	local language = language_for_ft and language_for_ft(ft) or nil

	if scope.ft then
		if type(scope.ft) == "string" then
			if ft ~= scope.ft then return false end
		elseif type(scope.ft) == "table" then
			if not vim.tbl_contains(scope.ft, ft) then return false end
		end
	end

	if scope.language then
		if type(scope.language) == "string" then
			if language ~= scope.language then return false end
		elseif type(scope.language) == "table" then
			if not vim.tbl_contains(scope.language, language) then return false end
		end
	end

	if not M.matches_project_markers(scope.project, bufnr) then return false end

	return true
end

function M.scope_score(scope)
	if not scope or vim.tbl_isempty(scope) then return 10 end
	if scope.project then return 40 end
	if scope.ft then return 30 end
	if scope.language then return 20 end
	return 10
end

function M.filter_and_sort_scoped(items, bufnr, language_for_ft)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local out = {}

	for _, item in ipairs(items or {}) do
		if M.matches_scope(item.scope, bufnr, language_for_ft) then
			local copy = vim.deepcopy(item)
			copy._score = M.scope_score(copy.scope)
			table.insert(out, copy)
		end
	end

	table.sort(out, function(a, b)
		if a._score == b._score then
			local an = a.name or a.id or ""
			local bn = b.name or b.id or ""
			return an < bn
		end
		return a._score > b._score
	end)

	for _, item in ipairs(out) do
		item._score = nil
	end

	return out
end

return M
