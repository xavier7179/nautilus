local M = {}

local templates = {
	{
		id = "node-js-package",
		name = "Node JS Package",
		group = "Node",
		order = 10,
		description = "Scaffold a plain Node JavaScript package",
		overwrite_strategy = "merge",
		smoke_run = { "npm", "test" },
		health_check = function(ctx)
			local checks = {}
			local package_json = ctx.abs_target_dir .. "/package.json"
			if vim.fn.filereadable(package_json) == 1 then
				table.insert(checks, { status = "pass", message = "package.json exists" })
			else
				table.insert(checks, { status = "fail", message = "package.json missing" })
			end
			if vim.fn.executable("node") == 1 then
				table.insert(checks, { status = "pass", message = "node available" })
			else
				table.insert(checks, { status = "fail", message = "node not found" })
			end
			if vim.fn.executable("npm") == 1 then
				table.insert(checks, { status = "pass", message = "npm available" })
			else
				table.insert(checks, { status = "warn", message = "npm not found" })
			end
			return checks
		end,
		prompts = {
			{ key = "project_name", label = "Project name", default = "node-js-package", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
			{ key = "install_deps", label = "Install deps", type = "boolean", default = false },
			{ key = "run_smoke", label = "Run smoke test", type = "boolean", default = false },
		},
	},
	{
		id = "react-electron-js-forge",
		name = "Electron Forge React JS",
		group = "Node",
		order = 20,
		description = "Scaffold Electron Forge app (Vite) then patch JS/React conventions",
		overwrite_strategy = "merge",
		smoke_run = { "npm", "run", "start" },
		health_check = function(ctx)
			local checks = {}
			local package_json = ctx.abs_target_dir .. "/package.json"
			if vim.fn.filereadable(package_json) == 1 then
				table.insert(checks, { status = "pass", message = "package.json exists" })
				local content = table.concat(vim.fn.readfile(package_json), "\n")
				if content:match('"electron"') then
					table.insert(checks, { status = "pass", message = "electron dependency found" })
				else
					table.insert(checks, { status = "warn", message = "electron not in dependencies" })
				end
			else
				table.insert(checks, { status = "fail", message = "package.json missing" })
			end
			if vim.fn.executable("node") == 1 then
				table.insert(checks, { status = "pass", message = "node available" })
			else
				table.insert(checks, { status = "fail", message = "node not found" })
			end
			if vim.fn.executable("npm") == 1 then
				table.insert(checks, { status = "pass", message = "npm available" })
			else
				table.insert(checks, { status = "warn", message = "npm not found" })
			end
			return checks
		end,
		prompts = {
			{ key = "project_name", label = "Project name", default = "electron-forge-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "app_display_name", label = "Display name", default = "{{project_name}}" },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
			{ key = "run_smoke", label = "Run start smoke", type = "boolean", default = false },
		},
	},
	{
		id = "cmake-cpp-app",
		name = "CMake C++ App",
		group = "C/C++",
		order = 10,
		description = "Scaffold a minimal CMake C++ executable project",
		overwrite_strategy = "merge",
		smoke_run = { "ctest", "--test-dir", "build", "--output-on-failure" },
		health_check = function(ctx)
			local checks = {}
			local cmake_lists = ctx.abs_target_dir .. "/CMakeLists.txt"
			if vim.fn.filereadable(cmake_lists) == 1 then
				table.insert(checks, { status = "pass", message = "CMakeLists.txt exists" })
			else
				table.insert(checks, { status = "fail", message = "CMakeLists.txt missing" })
			end
			if vim.fn.executable("cmake") == 1 then
				table.insert(checks, { status = "pass", message = "cmake available" })
			else
				table.insert(checks, { status = "fail", message = "cmake not found" })
			end
			if vim.fn.executable("ctest") == 1 then
				table.insert(checks, { status = "pass", message = "ctest available" })
			else
				table.insert(checks, { status = "warn", message = "ctest not found" })
			end
			if vim.fn.executable("g++") == 1 or vim.fn.executable("clang++") == 1 then
				table.insert(checks, { status = "pass", message = "C++ compiler available" })
			else
				table.insert(checks, { status = "fail", message = "no C++ compiler (g++/clang++)" })
			end
			return checks
		end,
		prompts = {
			{ key = "project_name", label = "Project name", default = "cpp-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "cpp_standard", label = "C++ standard", default = "20", required = true },
			{ key = "run_smoke", label = "Run tests after build", type = "boolean", default = false },
		},
	},
	{
		id = "rust-bin",
		name = "Rust Binary Crate",
		group = "Rust",
		order = 10,
		description = "Run cargo new --bin and patch basic project metadata",
		overwrite_strategy = "merge",
		smoke_run = { "cargo", "test" },
		health_check = function(ctx)
			local checks = {}
			local cargo_toml = ctx.abs_target_dir .. "/Cargo.toml"
			if vim.fn.filereadable(cargo_toml) == 1 then
				table.insert(checks, { status = "pass", message = "Cargo.toml exists" })
			else
				table.insert(checks, { status = "fail", message = "Cargo.toml missing" })
			end
			if vim.fn.executable("cargo") == 1 then
				table.insert(checks, { status = "pass", message = "cargo available" })
			else
				table.insert(checks, { status = "fail", message = "cargo not found" })
			end
			if vim.fn.executable("rustc") == 1 then
				table.insert(checks, { status = "pass", message = "rustc available" })
			else
				table.insert(checks, { status = "fail", message = "rustc not found" })
			end
			if vim.fn.executable("bacon") == 1 then
				table.insert(checks, { status = "pass", message = "bacon available (optional)" })
			else
				table.insert(checks, { status = "warn", message = "bacon not installed (optional)" })
			end
			return checks
		end,
		prompts = {
			{ key = "project_name", label = "Project name", default = "rust-app", required = true },
			{ key = "target_dir", label = "Target directory", default = "./{{project_name}}", required = true },
			{ key = "author", label = "Author", default = "" },
			{ key = "license", label = "License", default = "MIT", required = true },
			{ key = "run_smoke", label = "Run tests after build", type = "boolean", default = false },
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
