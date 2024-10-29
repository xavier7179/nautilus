return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates counting

		lualine.setup({
			options = {
				theme = "onedark",
			},
			-- add on Section X the update status (and keep the rest)
			sections = {
				lualine_x = {
					{
						"overseer",
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
			extensions = {
				-- "fugitive", "quickfix", "fzf", "oil"
				"lazy",
				"mason",
				"nvim-dap-ui",
				"trouble",
			},
		})
	end,
}
