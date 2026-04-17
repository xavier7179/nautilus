-- Disable autoformat for markdown buffers only (buffer-local scope)
vim.b.disable_autoformat = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.opt_local.tabstop = 2 -- spaces for tab
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2 -- spaces for indent width

vim.keymap.set("n", "<leader>mm", function()
	require("snacks")
		.toggle({
			name = "Toggle Render Markdown",
			get = function() return require("render-markdown.state").enabled end,
			set = function(enabled)
				local m = require("render-markdown")
				if enabled then
					m.enable()
				else
					m.disable()
				end
			end,
		})
		:toggle()
end, { buffer = true, desc = "Toggle Render Markdown" })
