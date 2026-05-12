-- Debuggers (hopefully for all supported languages
local lang = require("nautilus.custom.lang")
return {
	{
		"mfussenegger/nvim-dap",
		ft = lang.ft_for("dap"),
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			{ "theHamsta/nvim-dap-virtual-text", lazy = true, opts = {} },
		},
		keys = {
			{ "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
			{
				"<leader>db",
				function() require("dap").toggle_breakpoint() end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>dc",
				function() require("dap").continue() end,
				desc = "Continue",
			},
			{
				"<leader>dC",
				function() require("dap").run_to_cursor() end,
				desc = "Run to Cursor",
			},
			{
				"<leader>di",
				function() require("dap").step_into() end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function() require("dap").step_out() end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function() require("dap").step_over() end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function() require("dap").pause() end,
				desc = "Pause",
			},
			{
				"<leader>dR",
				function() require("dap").repl.toggle() end,
				desc = "Toggle REPL",
			},
			{
				"<leader>dt",
				function() require("dap").terminate() end,
				desc = "Terminate",
			},
			{
				"<leader>du",
				function() require("dapui").toggle({}) end,
				desc = "Dap UI",
			},
			{
				"<leader>de",
				function() require("dapui").eval() end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		config = function() vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" }) end,
	},

	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "nvim-neotest/nvim-nio" },
		opts = {
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			layouts = {
				{
					elements = {
						{ id = "scopes",      size = 0.25 },
						{ id = "watches",     size = 0.25 },
						{ id = "stacks",      size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
					},
					size = 40,
					position = "right",
				},
				{
					elements = { "repl", "console" },
					size = 10,
					position = "bottom",
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)

			-- Open DAP UI when a debug session initialises (buffers exist at this point).
			dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
			-- Close DAP UI on session end so right edge returns to its previous state.
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
		end,
	},
}
