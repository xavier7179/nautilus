-- lua/custom/save-colors.lua

local M = {}
local loading_colorscheme = false
local startup_load_failed = false
local startup_complete = false
local user_changed_colorscheme = false

local function valid_colorscheme(value)
	if type(value) ~= "string" then return false end
	value = vim.trim(value)
	return value ~= "" and not value:find("[%c/]"), value
end

local function colorscheme_file()
	local dir = vim.fn.stdpath("data") .. "/nautilus"
	vim.fn.mkdir(dir, "p")
	return dir .. "/colorscheme"
end

---@return string
function M.get_default_colorscheme()
	local configured = vim.g.nautilus_default_colorscheme
	if type(configured) == "string" then
		configured = vim.trim(configured)
		if configured ~= "" then return configured end
	end
	vim.g.nautilus_default_colorscheme = "default"
	return "default"
end

---@param fallback? string
---@return string
function M.get_colorscheme(fallback)
	fallback = fallback or M.get_default_colorscheme()
	local f = io.open(colorscheme_file(), "r")
	if not f then return fallback end
	local name = f:read("*l")
	f:close()
	local valid, normalized = valid_colorscheme(name)
	if valid then return normalized end
	return fallback
end

---@param colorscheme? string
function M.save_colorscheme(colorscheme)
	colorscheme = colorscheme or vim.g.colors_name
	local valid, normalized = valid_colorscheme(colorscheme)
	if not valid then return false end

	local file = colorscheme_file()
	local f = io.open(file, "r")
	if f then
		local existing = f:read("*l")
		f:close()
		if existing == normalized then return true end
	end

	-- Use a process-specific temporary file and rename it into place. A rename
	-- is atomic, so concurrent Neovim instances cannot leave a partial value.
	local temporary = string.format("%s.%d.tmp", file, vim.fn.getpid())
	f = io.open(temporary, "w")
	if not f then return false end
	f:write(normalized, "\n")
	f:close()
	if os.rename(temporary, file) then return true end
	os.remove(temporary)
	return false
end

function M.load_colorscheme()
	-- migrate from old shada-persisted vim.g.COLORS_NAME
	local file = colorscheme_file()
	local f = io.open(file, "r")
	if not f and valid_colorscheme(vim.g.COLORS_NAME) then
		M.save_colorscheme(vim.g.COLORS_NAME)
	elseif f then
		f:close()
	end
	local name = M.get_colorscheme()
	if not name then return false end

	loading_colorscheme = true
	local ok = pcall(vim.cmd.colorscheme, name)
	loading_colorscheme = false
	startup_load_failed = not ok
	startup_complete = true

	if not ok then
		-- Do not let a stale or unavailable persisted theme leave startup in an
		-- unusable state. Keep the persisted value intact so installing the theme
		-- later can restore it, and use the configured fallback for this session.
		local fallback = M.get_default_colorscheme()
		if fallback ~= name then
			loading_colorscheme = true
			pcall(vim.cmd.colorscheme, fallback)
			loading_colorscheme = false
		end
	end

	return ok
end

---@module 'lazy.types'

---@class ColorschemePluginSpec : LazyPluginSpec
---@field pattern? string|string[]

---@alias ColorschemeSpec string|ColorschemePluginSpec

local tbl_wrap = function(v) return type(v) == "table" and v or { v } end

---@param plugins ColorschemeSpec[]
---@return LazyPluginSpec[]
function M.tune_colorscheme_plugins(plugins)
	plugins = vim.iter(plugins):map(tbl_wrap)

	local get_name = function(plug)
		local plugin_spec_get_name = require("lazy.core.plugin").Spec.get_name
		local name = plug.name
			or plug[1] and plugin_spec_get_name(plug[1])
			or plug.url and plugin_spec_get_name(plug.url)
			or plug.dir and plugin_spec_get_name(plug.dir)
		return string.gsub(name, "[-.]nvim$", "")
	end

	local match_colorscheme = function(plug, colorscheme)
		local pattern = plug.pattern
		if not pattern then
			local name = get_name(plug)
			if name then pattern = string.gsub(name, "-", "%%-") end
		end
		return vim.iter(tbl_wrap(pattern)):any(function(pat) return string.match(colorscheme, "^" .. pat .. "$") end)
	end

	local colorscheme = M.get_colorscheme()

	plugins = plugins:map(function(plug)
		if match_colorscheme(plug, colorscheme) then
			return vim.tbl_extend("keep", plug, { lazy = false, priority = 1000 })
		else
			return vim.tbl_extend("keep", plug, { lazy = true })
		end
	end)

	return plugins:totable()
end

---@param plugins ColorschemeSpec[]
---@return LazyPluginSpec[]
function M.lazy_setup(plugins)
	local aug = vim.api.nvim_create_augroup("save_colors", { clear = true })

	vim.api.nvim_create_autocmd("User", {
		pattern = { "LazyDone", "VeryLazy" },
		group = aug,
		callback = function()
			M.load_colorscheme()
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = aug,
		callback = function(event)
			if loading_colorscheme then return end
			-- onenord.nvim's util.lua fires `doautocmd ColorScheme` without a
			-- pattern during setup(), yielding event.match == "". Guard against
			-- any such spurious event to avoid empty writes to the persistence file.
			if event.match == "" or not startup_complete then return end
			startup_load_failed = false
			user_changed_colorscheme = true
			M.save_colorscheme(event.match)
		end,
	})

	vim.api.nvim_create_autocmd("VimLeave", {
		group = aug,
		callback = function()
			-- A failed startup load or a session that never changed themes must not
			-- overwrite the user's persisted selection with a fallback/default.
			if startup_load_failed or not user_changed_colorscheme then return end
			M.save_colorscheme(vim.g.colors_name)
		end,
	})
	return M.tune_colorscheme_plugins(plugins)
end
return M
