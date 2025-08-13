vim.g.disable_autoformat = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

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
	:map("<leader>um")
