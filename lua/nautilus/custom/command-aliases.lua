local M = {}

local group_order = {
	Files = 10,
	Search = 20,
	Code = 30,
	Diagnostics = 40,
	Tests = 50,
	Tasks = 60,
	Debug = 70,
	Workflow = 80,
	AI = 90,
}

local function notify_missing(plugin)
	vim.notify(("Action unavailable: missing %s"):format(plugin), vim.log.levels.WARN)
end

local function with_module(name, fn)
	return function(...)
		local ok, mod = pcall(require, name)
		if not ok then
			notify_missing(name)
			return
		end
		return fn(mod, ...)
	end
end

local aliases = {
	{
		id = "files",
		label = "Files: Find",
		group = "Files",
		order = 10,
		run = with_module("snacks", function(snacks) snacks.picker.files({ layout = "telescope" }) end),
	},
	{
		id = "recent",
		label = "Files: Recent",
		group = "Files",
		order = 20,
		run = with_module("snacks", function(snacks) snacks.picker.recent({ layout = "telescope" }) end),
	},
	{
		id = "grep",
		label = "Search: Grep",
		group = "Search",
		order = 10,
		run = with_module("snacks", function(snacks) snacks.picker.grep({ layout = "telescope" }) end),
	},
	{
		id = "symbols_doc",
		label = "Code: Document Symbols",
		group = "Code",
		order = 10,
		run = with_module("snacks.picker", function(picker) picker.lsp_symbols() end),
	},
	{
		id = "symbols_workspace",
		label = "Code: Workspace Symbols",
		group = "Code",
		order = 20,
		run = with_module("snacks.picker", function(picker) picker.lsp_workspace_symbols() end),
	},
	{
		id = "diagnostics_project",
		label = "Diagnostics: Project",
		group = "Diagnostics",
		order = 10,
		run = function() vim.cmd("Trouble diagnostics toggle") end,
	},
	{
		id = "diagnostics_buffer",
		label = "Diagnostics: Buffer",
		group = "Diagnostics",
		order = 20,
		run = function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end,
	},
	{
		id = "test_nearest",
		label = "Tests: Nearest",
		group = "Tests",
		order = 10,
		run = with_module("neotest", function(neotest) neotest.run.run() end),
	},
	{
		id = "test_file",
		label = "Tests: File",
		group = "Tests",
		order = 20,
		run = with_module("neotest", function(neotest) neotest.run.run(vim.fn.expand("%")) end),
	},
	{
		id = "tasks_run",
		label = "Tasks: Run",
		group = "Tasks",
		order = 10,
		run = function() vim.cmd("OverseerRun") end,
	},
	{
		id = "tasks_toggle",
		label = "Tasks: Toggle Panel",
		group = "Tasks",
		order = 20,
		run = function() vim.cmd("OverseerToggle") end,
	},
	{
		id = "debug_preset",
		label = "Debug: Run Preset",
		group = "Debug",
		order = 10,
		run = function() vim.cmd("RunDebugPreset") end,
	},
	{
		id = "pipeline",
		label = "Workflow: Run Pipeline",
		group = "Workflow",
		order = 10,
		run = function() vim.cmd("RunPipeline") end,
	},
	{
		id = "workspace_health",
		label = "Workflow: Workspace Health",
		group = "Workflow",
		order = 20,
		run = function() vim.cmd("WorkspaceHealth") end,
	},
	{
		id = "inspection_profile",
		label = "Workflow: Inspection Profile",
		group = "Workflow",
		order = 30,
		run = function() vim.cmd("InspectionProfile") end,
	},
	{
		id = "agent_actions",
		label = "AI: Agent Actions",
		group = "AI",
		order = 10,
		run = function() vim.cmd("AgentActions") end,
	},
}

local function sorted_aliases()
	local out = vim.deepcopy(aliases)
	table.sort(out, function(a, b)
		local ga = group_order[a.group] or 999
		local gb = group_order[b.group] or 999
		if ga ~= gb then return ga < gb end
		if (a.order or 999) ~= (b.order or 999) then return (a.order or 999) < (b.order or 999) end
		return a.label < b.label
	end)
	return out
end

function M.list()
	return sorted_aliases()
end

function M.run(id)
	for _, alias in ipairs(aliases) do
		if alias.id == id then
			alias.run()
			return true
		end
	end
	return false
end

function M.display_label(item)
	return ("[%s] %s"):format(item.group, item.label)
end

return M
