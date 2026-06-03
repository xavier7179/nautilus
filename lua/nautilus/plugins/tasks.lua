local lang = require("nautilus.custom.lang")
local core = require("nautilus.core.functions")
local pipeline_registry = require("nautilus.custom.pipeline-registry")

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
	return require("overseer")
		.new_task({
			cmd = cmd[1],
			args = vim.list_slice(cmd, 2),
			cwd = vim.fn.getcwd(),
			components = { "default" },
		})
end

local function task_command_label(cmd)
	if vim.tbl_isempty(cmd) then return "" end
	return table.concat(cmd, " ")
end

local function run_pipeline(pipeline)
	if not pipeline then
		vim.notify("No pipeline selected", vim.log.levels.WARN)
		return
	end

	if vim.tbl_isempty(pipeline.steps or {}) then
		vim.notify(("Pipeline '%s' has no steps"):format(pipeline.name), vim.log.levels.WARN)
		return
	end

	vim.g.nautilus_last_pipeline_id = pipeline.id

	local index = 1
	local total = #pipeline.steps
	local stop_on_fail = pipeline.stop_on_fail ~= false

	local function run_step()
		local cmd = pipeline.steps[index]
		if not cmd then
			vim.notify(("Pipeline '%s' completed (%d steps)"):format(pipeline.name, total), vim.log.levels.INFO)
			return
		end

		local task = start_task(cmd)
		task:subscribe("on_complete", function(_, status)
			if status ~= "SUCCESS" and stop_on_fail then
				vim.notify(
					("Pipeline '%s' failed at step %d/%d: %s"):format(
						pipeline.name,
						index,
						total,
						task_command_label(cmd)
					),
					vim.log.levels.ERROR
				)
				return false
			end

			index = index + 1
			run_step()
			return false
		end)

		task:start()
	end

	vim.notify(("Starting pipeline '%s' (%d steps)"):format(pipeline.name, total), vim.log.levels.INFO)
	run_step()
end

local function pick_pipeline()
	local items = pipeline_registry.list_for_buffer(0)
	core.select_with_snacks(items, {
		prompt = "Task Pipelines",
		format_item = function(item) return item.name end,
		empty_message = "No pipelines available for current buffer",
	}, function(choice)
		if not choice then return end
		run_pipeline(choice)
	end)
end

local function rerun_last_pipeline()
	local pipeline = pipeline_registry.get(vim.g.nautilus_last_pipeline_id, 0) or pipeline_registry.default_for_buffer(0)
	if not pipeline then
		vim.notify("No pipeline available to rerun", vim.log.levels.WARN)
		return
	end
	run_pipeline(pipeline)
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
			:start()
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
			{ "<leader>op", pick_pipeline, desc = "Run Pipeline" },
			{ "<leader>oP", rerun_last_pipeline, desc = "Run Last Pipeline" },
		},
	},
}
