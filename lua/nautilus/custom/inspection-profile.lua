local M = {}

local profiles = { "strict", "normal", "fast" }
local default_profile = "normal"

local function is_valid(profile)
	return vim.tbl_contains(profiles, profile)
end

function M.all()
	return vim.deepcopy(profiles)
end

function M.get()
	if not is_valid(vim.g.nautilus_inspection_profile) then
		vim.g.nautilus_inspection_profile = default_profile
	end
	return vim.g.nautilus_inspection_profile
end

function M.set(profile)
	if not is_valid(profile) then return false end
	vim.g.nautilus_inspection_profile = profile
	return true
end

return M
