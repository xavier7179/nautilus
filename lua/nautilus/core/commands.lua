local core = require("nautilus.core.functions")
local lang = require("nautilus.custom.lang")
local action_aliases = require("nautilus.custom.command-aliases")
local inspection_profile = require("nautilus.custom.inspection-profile")
local template_engine = require("nautilus.custom.template-engine")
local template_registry = require("nautilus.custom.template-registry")
local workspace_health = require("nautilus.custom.workspace-health")

local function fmt_list(xs)
	if not xs or vim.tbl_isempty(xs) then return "-" end
	return table.concat(xs, ", ")
end

-- Create a FormatDisable command
vim.api.nvim_create_user_command("FormatDisable", core.disableAutoFormatting, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", core.enableAutoFormatting, {
	desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("LangInfo", function()
	local ft = vim.bo.filetype
	local lang_name = lang.language_for_ft(ft)

	if not lang_name then
		vim.notify(("No language registered for filetype '%s'"):format(ft), vim.log.levels.WARN)
		return
	end

	local lines = {
		("filetype: %s"):format(ft),
		("language: %s"):format(lang_name),
		"",
		"services:",
	}

	local names = { "lsp", "format", "lint", "dap", "completion", "tests", "tasks" }
	for _, service_name in ipairs(names) do
		local raw = lang.raw_service(lang_name, service_name)
		local enabled = lang.is_enabled(lang_name, service_name)
		local status = enabled and "enabled" or "disabled"

		if not vim.tbl_isempty(raw) then table.insert(lines, ("  - %s: %s"):format(service_name, status)) end
	end

	local tasks = lang.task_commands(lang_name)
	table.insert(lines, "")
	table.insert(lines, "tasks:")
	table.insert(lines, "  " .. fmt_list(vim.tbl_keys(tasks)))

	local raw_tests = lang.raw_service(lang_name, "tests")
	table.insert(lines, "")
	table.insert(lines, "test adapters:")
	table.insert(lines, "  " .. fmt_list(raw_tests.adapters or {}))

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "LangInfo" })
end, {
	desc = "Show resolved language configuration for current buffer",
})

vim.api.nvim_create_user_command(
	"ToolsSync",
	function() vim.cmd("MasonToolsInstall") end,
	{ desc = "Install/update configured Mason tools" }
)

vim.api.nvim_create_user_command("InspectionProfile", function(args)
	local profile = vim.trim(args.args or "")
	local project = args.bang

	if profile == "" then
		vim.notify(("Inspection profile: %s"):format(inspection_profile.get(0)), vim.log.levels.INFO)
		return
	end

	if not inspection_profile.set(profile, { project = project, bufnr = 0 }) then
		vim.notify("Invalid inspection profile. Use: strict, normal, fast", vim.log.levels.ERROR)
		return
	end

	local scope = project and " (project)" or " (global)"
	vim.notify(("Inspection profile set to: %s%s"):format(profile, scope), vim.log.levels.INFO)
end, {
	desc = "Show or set inspection profile (! for project scope)",
	nargs = "?",
	bang = true,
	complete = function() return inspection_profile.all() end,
})

vim.api.nvim_create_user_command("WorkspaceHealth", function() workspace_health.notify(0) end, {
	desc = "Show workspace health report",
})

vim.api.nvim_create_user_command("RunDebugPreset", function()
	core.feed_mapping("<leader>dr")
end, {
	desc = "Pick and run a debug preset",
})

vim.api.nvim_create_user_command("RunPipeline", function()
	core.feed_mapping("<leader>op")
end, {
	desc = "Pick and run a pipeline",
})

vim.api.nvim_create_user_command("AgentActions", function() require("nautilus.custom.prompts").pick() end, {
	desc = "Open AI agent actions picker",
})

vim.api.nvim_create_user_command("Action", function()
	local items = action_aliases.list()
	core.select_with_snacks(items, {
		prompt = "Action Palette",
		format_item = action_aliases.display_label,
		empty_message = "No action aliases configured",
	}, function(choice)
		if not choice then return end
		action_aliases.run(choice.id)
	end)
end, {
	desc = "Open workflow action palette",
})

vim.api.nvim_create_user_command("TemplateNew", function()
	local items = template_registry.list()
	core.select_with_snacks(items, {
		prompt = "Project Templates",
		format_item = function(item) return ("[%s] %s"):format(item.group, item.name) end,
		empty_message = "No templates registered",
	}, function(choice)
		if not choice then return end
		local result, err = template_engine.create(choice.id)
		if not result then
			vim.notify(("Template '%s' failed: %s"):format(choice.name, err), vim.log.levels.ERROR)
			return
		end
		vim.notify(("Template '%s' created at %s"):format(choice.name, result.context.abs_target_dir), vim.log.levels.INFO)
	end)
end, {
	desc = "Create a new project from template",
})
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("nautilus-highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.linebreak = true
	end,
})
