local M = {}

local profiles = { "strict", "normal", "fast" }
local default_profile = "normal"
local user_event = "NautilusInspectionProfileChanged"

local profile_config = {
	strict = {
		lint_events = {
			BufEnter = true,
			InsertLeave = true,
			BufWritePost = true,
		},
		diagnostics = {
			update_in_insert = true,
			virtual_text = {
				source = "always",
				spacing = 2,
			},
		},
	},
	normal = {
		lint_events = {
			BufEnter = false,
			InsertLeave = true,
			BufWritePost = true,
		},
		diagnostics = {
			update_in_insert = false,
			virtual_text = {
				source = "if_many",
				spacing = 2,
			},
		},
	},
	fast = {
		lint_events = {
			BufEnter = false,
			InsertLeave = false,
			BufWritePost = true,
		},
		diagnostics = {
			update_in_insert = false,
			virtual_text = false,
		},
	},
}

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
	vim.api.nvim_exec_autocmds("User", {
		pattern = user_event,
		data = { profile = profile },
	})
	return true
end

function M.lint_events(profile)
	profile = profile or M.get()
	return vim.deepcopy((profile_config[profile] or profile_config[default_profile]).lint_events)
end

function M.diagnostics(profile)
	profile = profile or M.get()
	return vim.deepcopy((profile_config[profile] or profile_config[default_profile]).diagnostics)
end

function M.event_name()
	return user_event
end

return M
