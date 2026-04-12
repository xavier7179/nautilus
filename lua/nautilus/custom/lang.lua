local registry = require("nautilus.custom.lang-registry")

local M = {}

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

local function get_service(lang, service)
	local spec = registry[lang]
	if not spec or not spec.services then return nil end
	return spec.services[service]
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

function M.spec(lang) return registry[lang] end

function M.has(lang, service)
	local svc = get_service(lang, service)
	return svc and svc.enabled or false
end

function M.languages_for(service)
	local out = {}
	for lang, _ in pairs(registry) do
		if M.has(lang, service) then table.insert(out, lang) end
	end
	table.sort(out)
	return out
end

function M.ft(lang)
	local spec = registry[lang]
	return spec and spec.ft or {}
end

function M.ft_for(service)
	local out = {}
	for _, lang in ipairs(M.languages_for(service)) do
		vim.list_extend(out, M.ft(lang))
	end
	return uniq(out)
end

function M.treesitter(lang)
	if lang then
		local spec = registry[lang]
		return uniq(spec and spec.treesitter or {})
	end

	local out = {}
	for _, spec in pairs(registry) do
		vim.list_extend(out, spec.treesitter or {})
	end
	return uniq(out)
end

function M.collect(service, field)
	local out = {}
	for _, lang in ipairs(M.languages_for(service)) do
		local svc = get_service(lang, service)
		vim.list_extend(out, svc and svc[field] or {})
	end
	return uniq(out)
end

function M.lsp_servers() return M.collect("lsp", "servers") end

function M.lsp_mason() return M.collect("lsp", "mason") end

function M.conform_formatters() return M.collect("format", "conform") end

function M.format_mason() return M.collect("format", "mason") end

function M.linters() return M.collect("lint", "linters") end

function M.lint_mason() return M.collect("lint", "mason") end

function M.dap_mason() return M.collect("dap", "mason") end

function M.completion_ft() return M.ft_for("completion") end

function M.by_ft(service, field)
	local out = {}
	for _, lang in ipairs(M.languages_for(service)) do
		local spec = registry[lang]
		local svc = get_service(lang, service)
		local values = svc and svc[field] or {}

		for _, ft in ipairs(spec.ft or {}) do
			out[ft] = vim.deepcopy(values)
		end
	end
	return out
end

function M.conform_by_ft() return M.by_ft("format", "conform") end

function M.linters_by_ft() return M.by_ft("lint", "linters") end

return M
