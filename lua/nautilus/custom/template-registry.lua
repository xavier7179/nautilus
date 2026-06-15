local M = {}

-- ── Shared health-check helpers ──────────────────────────────────────────────

local function add(checks, status, message)
	table.insert(checks, { status = status, message = message })
end

local function check_file(ctx, filename, checks, label)
	label = label or filename
	local path = ctx.abs_target_dir .. "/" .. filename
	if vim.fn.filereadable(path) == 1 then
		add(checks, "pass", label .. " exists")
	else
		add(checks, "fail", label .. " missing")
	end
end

---@param binary string
---@param checks table
---@param opts? { level?: "fail"|"warn"|"pass", label?: string }
local function check_exec(binary, checks, opts)
	opts = opts or {}
	local label = opts.label or binary
	local level = opts.level or "fail"
	if vim.fn.executable(binary) == 1 then
		add(checks, "pass", label .. " available")
	else
		add(checks, level, label .. " not found")
	end
end

---@param binaries string[]
---@param checks table
---@param opts? { level?: "fail"|"warn"|"pass", label?: string }
local function check_any_exec(binaries, checks, opts)
	opts = opts or {}
	local label = opts.label or table.concat(binaries, "/")
	local level = opts.level or "fail"
	for _, bin in ipairs(binaries) do
		if vim.fn.executable(bin) == 1 then
			add(checks, "pass", label .. " available")
			return
		end
	end
	add(checks, level, "no " .. label)
end

-- ── Templates ────────────────────────────────────────────────────────────────

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
			check_file(ctx, "package.json", checks)
			check_exec("node", checks)
			check_exec("npm", checks, { level = "warn" })
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
				add(checks, "pass", "package.json exists")
				local content = table.concat(vim.fn.readfile(package_json), "\n")
				if content:match('"electron"') then
					add(checks, "pass", "electron dependency found")
				else
					add(checks, "warn", "electron not in dependencies")
				end
			else
				add(checks, "fail", "package.json missing")
			end
			check_exec("node", checks)
			check_exec("npm", checks, { level = "warn" })
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
			check_file(ctx, "CMakeLists.txt", checks)
			check_exec("cmake", checks)
			check_exec("ctest", checks, { level = "warn" })
			check_any_exec({ "g++", "clang++" }, checks, { label = "C++ compiler (g++/clang++)" })
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
			check_file(ctx, "Cargo.toml", checks)
			check_exec("cargo", checks)
			check_exec("rustc", checks)
			check_exec("bacon", checks, { level = "warn", label = "bacon (optional)" })
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
