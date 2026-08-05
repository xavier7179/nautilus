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
	{
		id = "docker-attach-container",
		name = "Docker: Attach to running container",
		scope = {
			language = "docker",
		},
		dap = {
			type = "docker",
			request = "attach",
			name = "Docker Attach",
			containerName = function()
				return vim.fn.input("Container name: ")
			end,
			port = 9229,
			host = "localhost",
		},
	},
	{
		id = "cmake-launch-target",
		name = "CMake: Launch build target",
		scope = {
			language = "cmake",
		},
		dap = {
			type = "codelldb",
			request = "launch",
			name = "CMake Launch Target",
			program = function()
				local target = vim.fn.input("CMake target: ")
				return vim.fn.getcwd() .. "/build/" .. target
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	},
	{
		id = "lua-run-file",
		name = "Lua: Run current file",
		scope = {
			language = "lua",
		},
		dap = {
			type = "nlua",
			request = "launch",
			name = "Lua Run Current File",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	},
	{
		id = "html-live-server",
		name = "HTML: Live Server",
		scope = {
			language = "html",
		},
		dap = {
			type = "chrome",
			request = "launch",
			name = "HTML Live Server",
			url = "http://localhost:8080",
			webRoot = "${workspaceFolder}",
		},
	},
	{
		id = "css-lint-file",
		name = "CSS: Lint current file",
		scope = {
			language = "css",
		},
		dap = {
			type = "node",
			request = "launch",
			name = "CSS Lint",
			program = "${workspaceFolder}/node_modules/.bin/stylelint",
			args = { "${file}" },
			cwd = "${workspaceFolder}",
		},
	},
	{
		id = "json-validate-file",
		name = "JSON: Validate current file",
		scope = {
			language = "json",
		},
		dap = {
			type = "node",
			request = "launch",
			name = "JSON Validate",
			program = "jq",
			args = { ".", "${file}" },
			cwd = "${workspaceFolder}",
		},
	},
	{
		id = "yaml-lint-file",
		name = "YAML: Lint current file",
		scope = {
			language = "yaml",
		},
		dap = {
			type = "node",
			request = "launch",
			name = "YAML Lint",
			program = "yamllint",
			args = { "${file}" },
			cwd = "${workspaceFolder}",
		},
	},
	{
		id = "python-launch-file",
		name = "Python: Launch current file",
		scope = {
			language = "python",
		},
		dap = {
			type = "python",
			request = "launch",
			name = "Python Launch current file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
	},
	{
		id = "markdown-preview",
		name = "Markdown: Preview",
		scope = {
			language = "markdown",
		},
		dap = {
			type = "chrome",
			request = "launch",
			name = "Markdown Preview",
			url = "http://localhost:8080",
			webRoot = "${workspaceFolder}",
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
