local lang = require("nautilus.custom.lang")
local scope = require("nautilus.custom.scope")

local M = {}

local pipelines = {
	{
		id = "cmake-configure-build-test",
		name = "CMake: Configure + Build + Test",
		scope = {
			language = "cmake",
		},
		stop_on_fail = true,
		steps = {
			{ "cmake", "-S", ".", "-B", "build" },
			{ "cmake", "--build", "build" },
			{ "ctest", "--test-dir", "build", "--output-on-failure" },
		},
	},
	{
		id = "node-lint-fix-build",
		name = "Node: Lint + Test + Build",
		scope = {
			language = "javascript",
			project = {
				markers = { "package.json" },
			},
		},
		stop_on_fail = true,
		steps = {
			{ "npm", "run", "lint" },
			{ "npm", "test" },
			{ "npm", "run", "build" },
		},
	},
	{
		id = "rust-build-test",
		name = "Rust: Build + Test",
		scope = {
			language = "rust",
		},
		stop_on_fail = true,
		steps = {
			{ "cargo", "build" },
			{ "cargo", "test" },
		},
	},
}

function M.list_for_buffer(bufnr)
	return scope.filter_and_sort_scoped(pipelines, bufnr, lang.language_for_ft)
end

function M.get(id, bufnr)
	if not id or id == "" then return nil end
	for _, pipeline in ipairs(M.list_for_buffer(bufnr)) do
		if pipeline.id == id then return pipeline end
	end
	return nil
end

function M.default_for_buffer(bufnr)
	local list = M.list_for_buffer(bufnr)
	return list[1]
end

return M
