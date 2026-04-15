vim.g.disable_autoformat = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.keymap.set("n", "<leader>um", function()
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
