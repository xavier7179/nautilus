local lang = require("nautilus.custom.lang")
local run_registry = require("nautilus.custom.run-registry")
local pipeline_registry = require("nautilus.custom.pipeline-registry")
local inspection_profile = require("nautilus.custom.inspection-profile")

local M = {}

local function parser_available(parser)
	local ok, parsers = pcall(require, "nvim-treesitter.parsers")
	if not ok then return nil end
	return parsers.has_parser(parser)
end

local function mason_package_status(packages)
	local ok, registry = pcall(require, "mason-registry")
	if not ok then return nil, "mason-registry unavailable" end

	local missing = {}
	for _, pkg in ipairs(packages) do
		local ok_pkg, package = pcall(registry.get_package, pkg)
		if not ok_pkg or not package or not package:is_installed() then table.insert(missing, pkg) end
	end

	return missing
end

local function service_mismatch_warnings(language)
	local out = {}
	if not language then return out end

	local tasks = lang.task_commands(language)
	if lang.is_enabled(language, "tasks") and vim.tbl_isempty(tasks) then
		table.insert(out, "tasks enabled but no task commands configured")
	end

	local tests = lang.raw_service(language, "tests")
	if lang.is_enabled(language, "tests") and vim.tbl_isempty(tests.adapters or {}) then
		table.insert(out, "tests enabled but no test adapters configured")
	end

	local lsp = lang.raw_service(language, "lsp")
	if lang.is_enabled(language, "lsp") and vim.tbl_isempty(lsp.servers or {}) then
		table.insert(out, "LSP enabled but no servers configured")
	end

	return out
end

local function external_tool_checks(language)
	local checks = {
		{ bin = "git", required = true, reason = "core VCS integrations" },
		{ bin = "rg", required = true, reason = "search pickers" },
		{ bin = "lazygit", required = false, reason = "Snacks lazygit" },
	}

	if language == "c" then
		table.insert(checks, { bin = "cppcheck", required = false, reason = "C/C++ MISRA checks" })
	elseif language == "rust" then
		table.insert(checks, { bin = "cargo", required = true, reason = "Rust build/test workflow" })
		table.insert(checks, { bin = "bacon", required = false, reason = "Rust background diagnostics" })
	elseif language == "javascript" then
		table.insert(checks, { bin = "node", required = true, reason = "JS/TS tooling" })
		table.insert(checks, { bin = "npm", required = true, reason = "JS/TS tasks/tests" })
	elseif language == "php" then
		table.insert(checks, { bin = "php", required = true, reason = "PHP runtime/debug" })
	elseif language == "cmake" then
		table.insert(checks, { bin = "cmake", required = true, reason = "CMake workflow" })
	end

	return checks
end

local function add_bucket_line(bucket, line)
	if not bucket[line] then bucket[line] = true end
end

local function sorted_bucket_lines(bucket)
	local out = {}
	for line, _ in pairs(bucket) do
		table.insert(out, line)
	end
	table.sort(out)
	return out
end

function M.report(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local language = lang.language_for_ft(ft)
	local debug_presets = run_registry.list_for_buffer(bufnr)
	local pipelines = pipeline_registry.list_for_buffer(bufnr)
	local pass, warn, fail = {}, {}, {}

	if ft == "" then
		add_bucket_line(warn, "buffer filetype is empty")
	elseif language then
		add_bucket_line(pass, ("language registry mapped filetype '%s' -> '%s'"):format(ft, language))
	else
		add_bucket_line(warn, ("filetype '%s' has no language registry entry"):format(ft))
	end

	if #debug_presets > 0 then
		add_bucket_line(pass, ("debug presets available: %d"):format(#debug_presets))
	else
		add_bucket_line(warn, "no debug presets available for current context")
	end

	if #pipelines > 0 then
		add_bucket_line(pass, ("pipelines available: %d"):format(#pipelines))
	else
		add_bucket_line(warn, "no pipelines available for current context")
	end

	local mason_expected = {}
	vim.list_extend(mason_expected, lang.lsp_mason())
	vim.list_extend(mason_expected, lang.format_mason())
	vim.list_extend(mason_expected, lang.lint_mason())
	vim.list_extend(mason_expected, lang.dap_mason())

	local seen = {}
	local mason_unique = {}
	for _, pkg in ipairs(mason_expected) do
		if pkg ~= "" and not seen[pkg] then
			seen[pkg] = true
			table.insert(mason_unique, pkg)
		end
	end

	local mason_missing, mason_err = mason_package_status(mason_unique)
	if mason_missing == nil then
		add_bucket_line(warn, ("cannot validate Mason packages: %s"):format(mason_err))
	elseif #mason_missing == 0 then
		add_bucket_line(pass, ("Mason packages installed: %d"):format(#mason_unique))
	else
		add_bucket_line(warn, ("missing Mason packages: %s"):format(table.concat(mason_missing, ", ")))
	end

	local parsers = language and lang.treesitter(language) or {}
	if not language then
		add_bucket_line(warn, "treesitter parser checks skipped (no language context)")
	elseif vim.tbl_isempty(parsers) then
		add_bucket_line(warn, ("no treesitter parsers declared for '%s'"):format(language))
	else
		local parser_missing = {}
		local parser_unknown = false
		for _, parser in ipairs(parsers) do
			local available = parser_available(parser)
			if available == nil then
				parser_unknown = true
				break
			end
			if not available then table.insert(parser_missing, parser) end
		end

		if parser_unknown then
			add_bucket_line(warn, "cannot validate treesitter parser availability")
		elseif #parser_missing == 0 then
			add_bucket_line(pass, ("treesitter parsers available: %d"):format(#parsers))
		else
			add_bucket_line(warn, ("missing treesitter parsers: %s"):format(table.concat(parser_missing, ", ")))
		end
	end

	for _, check in ipairs(external_tool_checks(language)) do
		if vim.fn.executable(check.bin) == 1 then
			add_bucket_line(pass, ("tool '%s' available (%s)"):format(check.bin, check.reason))
		elseif check.required then
			add_bucket_line(fail, ("missing required tool '%s' (%s)"):format(check.bin, check.reason))
		else
			add_bucket_line(warn, ("missing optional tool '%s' (%s)"):format(check.bin, check.reason))
		end
	end

	for _, mismatch in ipairs(service_mismatch_warnings(language)) do
		add_bucket_line(warn, mismatch)
	end

	local lines = {
		"Workspace Health",
		"",
		("buffer filetype: %s"):format(ft ~= "" and ft or "(none)"),
		("language resolved: %s"):format(language or "(none)"),
		("inspection profile: %s"):format(inspection_profile.get()),
		"",
		"PASS:",
	}

	for _, line in ipairs(sorted_bucket_lines(pass)) do
		table.insert(lines, "  - " .. line)
	end
	if vim.tbl_isempty(pass) then table.insert(lines, "  - none") end

	table.insert(lines, "")
	table.insert(lines, "WARN:")
	for _, line in ipairs(sorted_bucket_lines(warn)) do
		table.insert(lines, "  - " .. line)
	end
	if vim.tbl_isempty(warn) then table.insert(lines, "  - none") end

	table.insert(lines, "")
	table.insert(lines, "FAIL:")
	for _, line in ipairs(sorted_bucket_lines(fail)) do
		table.insert(lines, "  - " .. line)
	end
	if vim.tbl_isempty(fail) then table.insert(lines, "  - none") end

	table.insert(lines, "")
	table.insert(lines, "Remediation:")
	table.insert(lines, "  - run :ToolsSync to install configured Mason packages")
	table.insert(lines, "  - run :TSUpdate to install/update treesitter parsers")
	table.insert(lines, "  - install missing external tools with brew/cargo/npm as needed")

	return lines
end

function M.notify(bufnr)
	vim.notify(table.concat(M.report(bufnr), "\n"), vim.log.levels.INFO, { title = "WorkspaceHealth" })
end

function M.remediate(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local language = lang.language_for_ft(ft)
	local actions = {}

	local mason_expected = {}
	vim.list_extend(mason_expected, lang.lsp_mason())
	vim.list_extend(mason_expected, lang.format_mason())
	vim.list_extend(mason_expected, lang.lint_mason())
	vim.list_extend(mason_expected, lang.dap_mason())

	local seen = {}
	local mason_unique = {}
	for _, pkg in ipairs(mason_expected) do
		if pkg ~= "" and not seen[pkg] then
			seen[pkg] = true
			table.insert(mason_unique, pkg)
		end
	end

	local mason_missing = mason_package_status(mason_unique)
	if mason_missing and #mason_missing > 0 then
		table.insert(actions, { cmd = "MasonToolsInstall", desc = "Install missing Mason packages: " .. table.concat(mason_missing, ", ") })
	end

	local parsers = language and lang.treesitter(language) or {}
	if language and not vim.tbl_isempty(parsers) then
		local parser_missing = {}
		for _, parser in ipairs(parsers) do
			local available = parser_available(parser)
			if available == false then table.insert(parser_missing, parser) end
		end
		if #parser_missing > 0 then
			table.insert(actions, { cmd = "TSUpdate " .. table.concat(parser_missing, " "), desc = "Install missing treesitter parsers: " .. table.concat(parser_missing, ", ") })
		end
	end

	for _, check in ipairs(external_tool_checks(language)) do
		if vim.fn.executable(check.bin) == 0 and check.required then
			table.insert(actions, { cmd = nil, desc = "Install required tool: " .. check.bin .. " (" .. check.reason .. ")" })
		end
	end

	return actions
end

function M.fix(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local actions = M.remediate(bufnr)
	local executed = {}

	for _, action in ipairs(actions) do
		if action.cmd then
			vim.cmd(action.cmd)
			table.insert(executed, action.desc)
		end
	end

	if #executed > 0 then
		vim.notify("WorkspaceHealth fix executed:\n  - " .. table.concat(executed, "\n  - "), vim.log.levels.INFO)
	else
		vim.notify("WorkspaceHealth: no auto-fixable issues found", vim.log.levels.INFO)
	end

	return executed
end

return M
