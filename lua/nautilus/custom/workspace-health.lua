local lang = require("nautilus.custom.lang")
local run_registry = require("nautilus.custom.run-registry")
local pipeline_registry = require("nautilus.custom.pipeline-registry")
local inspection_profile = require("nautilus.custom.inspection-profile")

local M = {}

local function yesno(v)
	if v then return "yes" end
	return "no"
end

function M.report(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local language = lang.language_for_ft(ft)
	local debug_presets = run_registry.list_for_buffer(bufnr)
	local pipelines = pipeline_registry.list_for_buffer(bufnr)

	local lines = {
		"Workspace Health",
		"",
		("buffer filetype: %s"):format(ft ~= "" and ft or "(none)"),
		("language resolved: %s"):format(language or "(none)"),
		("language registered: %s"):format(yesno(language ~= nil)),
		("inspection profile: %s"):format(inspection_profile.get()),
		"",
		("debug presets in context: %d"):format(#debug_presets),
		("pipelines in context: %d"):format(#pipelines),
	}

	return lines
end

function M.notify(bufnr)
	vim.notify(table.concat(M.report(bufnr), "\n"), vim.log.levels.INFO, { title = "WorkspaceHealth" })
end

return M
