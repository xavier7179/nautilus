local lang = require("nautilus.custom.lang")

local adapter_factories = {
	plenary = function()
		local ok, adapter = pcall(require, "neotest-plenary")
		return ok and adapter or nil
	end,
	rust = function()
		local ok, adapter = pcall(require, "neotest-rust")
		return ok and adapter or nil
	end,
	vitest = function()
		local ok, adapter = pcall(require, "neotest-vitest")
		if not ok then return nil end
		return adapter({
			filter_dir = function(name) return name ~= "node_modules" end,
		})
	end,
	jest = function()
		local ok, adapter = pcall(require, "neotest-jest")
		if not ok then return nil end
		return adapter({
			jestCommand = "npm test --",
			jestConfigFile = function(file)
				-- Resolve jest config relative to the detected project root
				local root = vim.fn.fnamemodify(
					vim.fn.findfile("jest.config.*", file .. ";"),
					":h"
				)
				return root ~= "" and root or nil
			end,
			env = { CI = "true" },
			cwd = function(path)
				return vim.fn.fnamemodify(
					vim.fn.findfile("package.json", path .. ";"),
					":h"
				)
			end,
		})
	end,
}

local function resolve_adapters()
	local out = {}

	for _, id in ipairs(lang.test_adapters()) do
		local factory = adapter_factories[id]

		if not factory then
			vim.notify(("Unknown neotest adapter id in registry: %s"):format(id), vim.log.levels.WARN)
			goto continue
		end

		local adapter = factory()
		if adapter then table.insert(out, adapter) end

		::continue::
	end

	return out
end

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-treesitter/nvim-treesitter",
			"stevearc/overseer.nvim",
			-- adapter plugins are declared in per-language files under plugins/lang/
		},
		cmd = { "Neotest", "NeotestSummary", "NeotestOutput", "NeotestRun" },
		keys = {
			{ "<leader>tn", function() require("neotest").run.run() end, desc = "Test Nearest" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test File" },
			{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test Last" },
			{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Test" },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
			{ "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test Output Panel" },
			{
				"<leader>tO",
				function() require("neotest").output.open({ enter = true, auto_close = true }) end,
				desc = "Test Output",
			},
			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop Test" },
		},
		opts = function()
			return {
				summary = {
					open = "botright vsplit | vertical resize 60",
				},
				output_panel = {
					enabled = true,
					open = "botright split | resize 12",
				},
				consumers = {
					overseer = require("neotest.consumers.overseer"),
				},
				overseer = {
					enabled = true,
					force_default = false,
				},
				adapters = resolve_adapters(),
			}
		end,
	},
}
