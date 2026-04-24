local core = require("nautilus.core.functions")
local lang = require("nautilus.custom.lang")

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
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
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
