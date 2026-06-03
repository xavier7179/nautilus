local lang = require("nautilus.custom.lang")

local M = {}

local presets = {
	{
		id = "cpp-launch-file",
		name = "C/C++: Launch file",
		scope = {
			language = "c",
		},
		dap = {
			type = "codelldb",
			request = "launch",
			name = "C/C++ Launch file",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	},
	{
		id = "js-launch-file",
		name = "JS/TS: Launch current file",
		scope = {
			language = "javascript",
			project = {
				markers = { "package.json" },
			},
		},
		dap = {
			type = "pwa-node",
			request = "launch",
			name = "JS/TS Launch current file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
	},
	{
		id = "php-run-current-script",
		name = "PHP: Run current script",
		scope = {
			language = "php",
		},
		dap = {
			type = "php",
			request = "launch",
			name = "PHP Run current script",
			program = "${file}",
			cwd = "${workspaceFolder}",
			port = 9003,
			runtimeExecutable = "php",
		},
	},
	{
		id = "bash-launch-file",
		name = "Shell: Launch current file",
		scope = {
			language = "bash",
		},
		dap = {
			type = "bashdb",
			request = "launch",
			name = "Shell Launch current file",
			showDebugOutput = true,
			pathBashdb = vim.fn.exepath("bashdb"),
			pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
			trace = true,
			file = "${file}",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pathCat = "cat",
			pathBash = "/bin/bash",
			pathMkfifo = "mkfifo",
			pathPkill = "pkill",
			args = {},
			env = {},
			terminalKind = "integrated",
		},
	},
}

local function buf_dir(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then return vim.fn.getcwd() end
	return vim.fn.fnamemodify(path, ":p:h")
end

local function score(scope)
	if not scope or vim.tbl_isempty(scope) then return 10 end
	if scope.project then return 40 end
	if scope.ft then return 30 end
	if scope.language then return 20 end
	return 10
end

local function matches_project(project_scope, bufnr)
	if not project_scope then return true end
	local markers = project_scope.markers or {}
	if vim.tbl_isempty(markers) then return true end

	local start = buf_dir(bufnr)
	for _, marker in ipairs(markers) do
		local found = vim.fn.findfile(marker, start .. ";")
		if found == "" then found = vim.fn.finddir(marker, start .. ";") end
		if found ~= "" then return true end
	end

	return false
end

local function matches_scope(scope, bufnr)
	if not scope or vim.tbl_isempty(scope) then return true end

	local ft = vim.bo[bufnr].filetype
	local language = lang.language_for_ft(ft)

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

	if not matches_project(scope.project, bufnr) then return false end

	return true
end

function M.list_for_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local out = {}

	for _, preset in ipairs(presets) do
		if matches_scope(preset.scope, bufnr) then
			local item = vim.deepcopy(preset)
			item._score = score(item.scope)
			table.insert(out, item)
		end
	end

	table.sort(out, function(a, b)
		if a._score == b._score then return a.name < b.name end
		return a._score > b._score
	end)

	for _, item in ipairs(out) do
		item._score = nil
	end

	return out
end

function M.get(id, bufnr)
	if not id or id == "" then return nil end
	for _, preset in ipairs(M.list_for_buffer(bufnr)) do
		if preset.id == id then return preset end
	end
	return nil
end

function M.default_for_buffer(bufnr)
	local list = M.list_for_buffer(bufnr)
	return list[1]
end

return M
