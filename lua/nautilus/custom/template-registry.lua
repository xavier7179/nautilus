local M = {}

local templates = {
	{
		id = "node-js-package",
		name = "Node JS Package",
		group = "Node",
		order = 10,
		description = "Scaffold a plain Node JavaScript package",
		overwrite_strategy = "merge",
		prompts = {
			{ key = "project_name", label = "Project name", default = "node-js-package", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
			{ key = "install_deps", label = "Install deps", type = "boolean", default = false },
		},
	},
	{
		id = "react-electron-js-forge",
		name = "Electron Forge React JS",
		group = "Node",
		order = 20,
		description = "Scaffold Electron Forge app (Vite) then patch JS/React conventions",
		overwrite_strategy = "merge",
		prompts = {
			{ key = "project_name", label = "Project name", default = "electron-forge-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "app_display_name", label = "Display name", default = "{{project_name}}" },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
			{ key = "run_start_smoke", label = "Run start smoke", type = "boolean", default = false },
		},
	},
	{
		id = "cmake-cpp-app",
		name = "CMake C++ App",
		group = "C/C++",
		order = 10,
		description = "Scaffold a minimal CMake C++ executable project",
		overwrite_strategy = "merge",
		prompts = {
			{ key = "project_name", label = "Project name", default = "cpp-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "cpp_standard", label = "C++ standard", default = "20", required = true },
		},
	},
	{
		id = "rust-bin",
		name = "Rust Binary Crate",
		group = "Rust",
		order = 10,
		description = "Run cargo new --bin and patch basic project metadata",
		overwrite_strategy = "merge",
		prompts = {
			{ key = "project_name", label = "Project name", default = "rust-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
		},
	},
}

local group_order = {
	["C/C++"] = 10,
	Node = 20,
	Rust = 30,
}

function M.list()
	local out = vim.deepcopy(templates)
	table.sort(out, function(a, b)
		local ga = group_order[a.group] or 999
		local gb = group_order[b.group] or 999
		if ga ~= gb then return ga < gb end
		if (a.order or 999) ~= (b.order or 999) then return (a.order or 999) < (b.order or 999) end
		return a.name < b.name
	end)
	return out
end

function M.get(id)
	for _, template in ipairs(templates) do
		if template.id == id then return vim.deepcopy(template) end
	end
	return nil
end

function M.ids()
	local ids = {}
	for _, template in ipairs(templates) do
		table.insert(ids, template.id)
	end
	table.sort(ids)
	return ids
end

return M
