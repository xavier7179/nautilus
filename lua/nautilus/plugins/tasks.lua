local lang = require("nautilus.custom.lang")

local function current_task_context()
	local ft = vim.bo.filetype
	local lang_name = lang.language_for_ft(ft)
	local commands = lang.tasks_by_ft()[ft] or {}

	return {
		ft = ft,
		lang = lang_name,
		commands = commands,
	}
end

local function start_task(cmd)
	require("overseer")
		.new_task({
			cmd = cmd[1],
			args = vim.list_slice(cmd, 2),
			cwd = vim.fn.getcwd(),
			components = { "default" },
		})
		:start()
end

local function run_lang_task(name)
	return function()
		local ctx = current_task_context()
		local cmd = ctx.commands[name]

		if not cmd or vim.tbl_isempty(cmd) then
			local label = ctx.lang and ("language '%s'"):format(ctx.lang) or ("filetype '%s'"):format(ctx.ft)
			vim.notify(("No '%s' task configured for %s"):format(name, label), vim.log.levels.WARN)
			return
		end

		start_task(cmd)
	end
end

return {
	{
		"stevearc/overseer.nvim",
		cmd = { "OverseerOpen", "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
		opts = {
			strategy = "jobstart",
			task_list = {
				direction = "bottom",
				min_height = 8,
				max_height = 20,
				default_detail = 1,
			},
		},
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Tasks" },
			{ "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "Task Action" },
			{ "<leader>oc", run_lang_task("configure"), desc = "Configure" },
			{ "<leader>ob", run_lang_task("build"), desc = "Build" },
			{ "<leader>od", run_lang_task("dev"), desc = "Dev Task" },
			{ "<leader>oR", run_lang_task("run"), desc = "Run Task (lang)" },
			{ "<leader>oT", run_lang_task("test"), desc = "Test Task" },
		},
	},
}
