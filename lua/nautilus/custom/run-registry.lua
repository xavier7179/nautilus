local lang = require("nautilus.custom.lang")
local scope = require("nautilus.custom.scope")

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

function M.list_for_buffer(bufnr)
	return scope.filter_and_sort_scoped(presets, bufnr, lang.language_for_ft)
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
