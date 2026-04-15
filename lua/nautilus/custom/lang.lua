local registry = require("nautilus.custom.lang-registry")

local M = {}
-- Contract:
-- - lang-registry.lua is the human-readable source of truth
-- - services may remain fully configured even when disabled
-- - this module exposes:
--   * raw accessors for inspection/debugging
--   * enabled-only accessors for runtime/plugin consumers

local function uniq(items)
	local seen = {}
	local out = {}

	for _, item in ipairs(items or {}) do
		if item and item ~= "" and not seen[item] then
			seen[item] = true
			table.insert(out, item)
		end
	end

	table.sort(out)
	return out
end

local function deepcopy(value) return vim.deepcopy(value) end

local function spec(lang) return registry[lang] end

local function raw_service_spec(lang, service)
	local lang_spec = spec(lang)
	if not lang_spec or not lang_spec.services then return nil end
	return lang_spec.services[service]
end

local function service_spec(lang, service)
	local svc = raw_service_spec(lang, service)
	if not svc or svc.enabled == false then return nil end

	return svc
end

function M.all() return registry end

function M.names()
	local out = {}
	for name, _ in pairs(registry) do
		table.insert(out, name)
	end
	table.sort(out)
	return out
end

function M.spec(lang) return spec(lang) end

function M.raw_service(lang, service) return deepcopy(raw_service_spec(lang, service) or {}) end

function M.service(lang, service) return deepcopy(service_spec(lang, service) or {}) end

function M.is_enabled(lang, service)
	local svc = raw_service_spec(lang, service)
	return svc ~= nil and svc.enabled ~= false
end

function M.has(lang, service) return service_spec(lang, service) ~= nil end

function M.languages_for(service)
	local out = {}
	for lang_name, _ in pairs(registry) do
		if M.has(lang_name, service) then table.insert(out, lang_name) end
	end
	table.sort(out)
	return out
end

function M.ft(lang)
	local lang_spec = spec(lang)
	return uniq(lang_spec and lang_spec.ft or {})
end

function M.language_for_ft(ft)
	for _, lang_name in ipairs(M.names()) do
		if vim.tbl_contains(M.ft(lang_name), ft) then return lang_name end
	end
	return nil
end

function M.services(lang)
	local out = {}
	local lang_spec = spec(lang)
	local all_services = lang_spec and lang_spec.services or {}

	for name, svc in pairs(all_services) do
		out[name] = {
			enabled = svc.enabled ~= false,
			config = deepcopy(svc),
		}
	end

	return out
end

function M.ft_for(service)
	local out = {}
	for _, lang_name in ipairs(M.languages_for(service)) do
		vim.list_extend(out, M.ft(lang_name))
	end
	return uniq(out)
end

function M.treesitter(lang)
	if lang then
		local lang_spec = spec(lang)
		return uniq(lang_spec and lang_spec.treesitter or {})
	end

	local out = {}
	for _, lang_spec in pairs(registry) do
		vim.list_extend(out, lang_spec.treesitter or {})
	end
	return uniq(out)
end

function M.collect(service, field)
	local out = {}
	for _, lang_name in ipairs(M.languages_for(service)) do
		local svc = service_spec(lang_name, service)
		vim.list_extend(out, svc and svc[field] or {})
	end
	return uniq(out)
end

function M.collect_map(service, field)
	local out = {}
	for _, lang_name in ipairs(M.languages_for(service)) do
		local svc = service_spec(lang_name, service)
		local values = svc and svc[field] or {}
		out[lang_name] = deepcopy(values)
	end
	return out
end

function M.by_ft(service, field)
	local out = {}
	for _, lang_name in ipairs(M.languages_for(service)) do
		local svc = service_spec(lang_name, service)
		local values = svc and svc[field] or {}

		for _, ft in ipairs(M.ft(lang_name)) do
			out[ft] = deepcopy(values)
		end
	end
	return out
end

function M.lsp_servers() return M.collect("lsp", "servers") end
function M.lsp_mason() return M.collect("lsp", "mason") end

function M.conform_formatters() return M.collect("format", "conform") end
function M.format_mason() return M.collect("format", "mason") end
function M.conform_by_ft() return M.by_ft("format", "conform") end

function M.linters() return M.collect("lint", "linters") end
function M.lint_mason() return M.collect("lint", "mason") end
function M.linters_by_ft() return M.by_ft("lint", "linters") end

function M.dap_mason() return M.collect("dap", "mason") end
function M.completion_ft() return M.ft_for("completion") end

function M.test_adapters() return M.collect("tests", "adapters") end
function M.tests_by_ft() return M.by_ft("tests", "adapters") end

function M.task_commands(lang) return M.service(lang, "tasks").commands or {} end
function M.tasks_by_lang() return M.collect_map("tasks", "commands") end
function M.tasks_by_ft() return M.by_ft("tasks", "commands") end

return M
