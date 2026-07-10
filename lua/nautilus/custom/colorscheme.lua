-- lua/custom/save-colors.lua

local M = {}

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
	if name and name ~= "" then return name end
	return fallback
end

---@param colorscheme? string
function M.save_colorscheme(colorscheme)
	colorscheme = colorscheme or vim.g.colors_name
	if not colorscheme or colorscheme == "" then return end
	local f = io.open(colorscheme_file(), "r")
	if f then
		local existing = f:read("*l")
		f:close()
		if existing == colorscheme then return end
	end
	f = io.open(colorscheme_file(), "w")
	if f then
		f:write(colorscheme)
		f:close()
	end
end

function M.load_colorscheme()
	-- migrate from old shada-persisted vim.g.COLORS_NAME
	local file = colorscheme_file()
	local f = io.open(file, "r")
	if not f and vim.g.COLORS_NAME and vim.g.COLORS_NAME ~= "" then
		f = io.open(file, "w")
		if f then
			f:write(vim.g.COLORS_NAME)
			f:close()
		end
	elseif f then
		f:close()
	end
	local name = M.get_colorscheme()
	if name then pcall(vim.cmd.colorscheme, name) end
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
			-- onenord.nvim's util.lua fires `doautocmd ColorScheme` without a
			-- pattern during setup(), yielding event.match == "". Guard against
			-- any such spurious event to avoid empty writes to the persistence file.
			if event.match == "" then return end
			M.save_colorscheme(event.match)
		end,
	})

	vim.api.nvim_create_autocmd("VimLeave", {
		group = aug,
		callback = function() M.save_colorscheme(vim.g.colors_name) end,
	})
	return M.tune_colorscheme_plugins(plugins)
end
return M