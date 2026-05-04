-- Initialise the MISRA flag to false the first time a C/C++ buffer is opened.
-- The flag is global (vim.g) because MISRA mode is a session-level decision that
-- applies to all open C/C++ buffers, not to individual files.
if vim.g.cppcheck_misra_enabled == nil then
	vim.g.cppcheck_misra_enabled = false
end

-- Buffer-local keymap: only active when a C/C++ buffer is focused.
-- The toggle state itself is global so switching in any C buffer affects all of them.
vim.keymap.set("n", "<leader>uM", function()
	require("snacks")
		.toggle({
			name = "MISRA Linting",
			get = function() return vim.g.cppcheck_misra_enabled == true end,
			set = function(state) vim.g.cppcheck_misra_enabled = state end,
		})
		:toggle()
end, { buffer = true, desc = "Toggle MISRA Linting" })
