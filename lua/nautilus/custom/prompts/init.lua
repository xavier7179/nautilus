-- Prompts: dynamic prompt library with YAML frontmatter + role sections
-- Each .md file in the prompts/ directory becomes an agent entry.
-- Supports ## system / ## user body sections and tools activation.

local M = {}

local function dir()
	return vim.g.nautilus_prompts_dir or vim.fn.stdpath("config") .. "/prompts"
end

-- Simple YAML frontmatter parser for the limited subset we use.
-- Handles:
--   key: scalar_value
--   one level of nested mapping (key: subkey: value)
--   block sequences (key: \n  - item)
local function parse_frontmatter(lines)
	local result = {}
	local stack = {}

	local function tobool(v)
		if v == "true" then return true end
		if v == "false" then return false end
		return v
	end

	for _, line in ipairs(lines) do
		local trimmed = line:match("^%s*(.-)%s*$")
		if trimmed == "" then goto continue end

		local indent = #line - #(line:gsub("^%s+", ""))

		while #stack > 0 and stack[#stack].indent >= indent do
			table.remove(stack)
		end

		local item = trimmed:match("^%-(.+)$")
		if item then
			item = item:match("^%s*(.-)%s*$")
			item = item:gsub('^"(.-)"$', "%1"):gsub("^'(.-)'$", "%1")
			if #stack > 0 then
				local parent_key = stack[#stack].key
				if type(result[parent_key]) ~= "table" then
					result[parent_key] = {}
				end
				table.insert(result[parent_key], item)
			end
			goto continue
		end

		local key, val = trimmed:match("^([%w_-]+):%s*(.-)$")
		if not key then goto continue end

		if val then
			val = val:gsub('^"(.-)"$', "%1"):gsub("^'(.-)'$", "%1")
		end

		if val and val ~= "" then
			val = tobool(val)
			if #stack == 0 then
				result[key] = val
			else
				local parent = result
				for _, s in ipairs(stack) do
					parent = parent[s.key]
				end
				parent[key] = val
			end
			table.insert(stack, { key = key, indent = indent })
		else
			if #stack == 0 then
				result[key] = {}
			else
				local parent = result
				for _, s in ipairs(stack) do
					parent = parent[s.key]
				end
				parent[key] = {}
			end
			table.insert(stack, { key = key, indent = indent })
		end

		::continue::
	end

	return result
end

local function parse_body(lines)
	local sections = {}
	local current_role = nil
	local current_lines = {}

	local function flush()
		if current_role then
			local content = vim.trim(table.concat(current_lines, "\n"))
			if content ~= "" then
				table.insert(sections, { role = current_role, content = content })
			end
			current_lines = {}
		end
	end

	for _, line in ipairs(lines) do
		local role = line:match("^##%s+(%w+)%s*$")
		if role and (role == "system" or role == "user") then
			flush()
			current_role = role
		else
			table.insert(current_lines, line)
		end
	end
	flush()

	return sections
end

local function parse_md(filepath)
	local lines = vim.fn.readfile(filepath)
	local frontmatter_lines = {}
	local body_lines = {}
	local in_frontmatter = false
	local parsed_frontmatter = false

	for _, line in ipairs(lines) do
		if not parsed_frontmatter and line:match("^---%s*$") then
			if not in_frontmatter then
				in_frontmatter = true
			else
				in_frontmatter = false
				parsed_frontmatter = true
			end
		elseif in_frontmatter then
			table.insert(frontmatter_lines, line)
		elseif parsed_frontmatter then
			table.insert(body_lines, line)
		end
	end

	local frontmatter = parse_frontmatter(frontmatter_lines)
	local body = parse_body(body_lines)

	local stem = vim.fn.fnamemodify(filepath, ":t:r")
	frontmatter.name = frontmatter.name or stem
	frontmatter.short_name = frontmatter.short_name or stem

	return frontmatter, body
end

local entries = nil

function M.get_entries()
	if entries then return entries end
	entries = {}
	local d = dir()
	if vim.fn.isdirectory(d) == 0 then return entries end
	for _, file in ipairs(vim.fn.readdir(d, [[v:val =~ '\.md$']])) do
		local frontmatter, body = parse_md(d .. "/" .. file)
		local short_name = frontmatter.short_name

		local entry = {
			interaction = frontmatter.interaction or "chat",
			description = frontmatter.description or frontmatter.name,
			opts = {
				short_name = short_name,
				alias = frontmatter.opts and frontmatter.opts.alias or short_name,
				is_default = false,
				auto_submit = false,
				ignore_system_prompt = frontmatter.opts and frontmatter.opts.ignore_system_prompt,
			},
		}

		if frontmatter.tools and #frontmatter.tools > 0 then
			entry.tools = frontmatter.tools
		end

		if body and #body > 0 then
			entry.prompts = {}
			for _, section in ipairs(body) do
				table.insert(entry.prompts, {
					role = section.role,
					content = section.content,
				})
			end
		end

		entries[frontmatter.name] = entry
	end
	return entries
end

function M.pick()
	local d = dir()
	if vim.fn.isdirectory(d) == 0 then
		vim.notify("Prompts directory not found: " .. d, vim.log.levels.WARN)
		return
	end
	local files = vim.fn.readdir(d, [[v:val =~ '\.md$']])
	if vim.tbl_isempty(files) then
		vim.notify("No .md prompt files found in " .. d, vim.log.levels.WARN)
		return
	end
	local items = {}
	for _, file in ipairs(files) do
		local frontmatter = parse_md(d .. "/" .. file)
		table.insert(items, {
			name = frontmatter.name,
			short_name = frontmatter.short_name,
			desc = frontmatter.description or "",
		})
	end
	vim.ui.select(items, {
		prompt = "Agents",
		format_item = function(i)
			local desc_part = i.desc ~= "" and (" \226\128\148 " .. i.desc) or ""
			return i.name .. desc_part
		end,
	}, function(choice)
		if choice then require("codecompanion").prompt(choice.name) end
	end)
end

return M
