return {
	{
		"echasnovski/mini.statusline",
		version = "*",
		opts = {
			use_icons = vim.g.have_nerd_font,
		},
		config = function()
			-- Mini.statusline configuration
			require("mini.statusline").setup({
				content = {
					-- Left section: Add your overseer and lazy status updates here
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 40 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
						-- local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = MiniStatusline.section_location({ trunc_width = 75 })
						local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
						-- Function to get overseer status
						-- TODO: instead # of running tasks provide details about the status
						local function get_overseer_status()
							local overseer = require("overseer")
							local tasks = overseer.list_tasks()
							if #tasks > 0 then
								return #tasks .. " tasks running"
							else
								return "No tasks running"
							end
						end
						-- Lazy status updates
						local lazy_status = require("lazy.status")
						local lazy_updates = ""
						if lazy_status.has_updates() then
							lazy_updates = string.format("Lazy: %s", lazy_status.updates())
						end

						-- Combine all sections
						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, lazy_updates, diagnostics, lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { get_overseer_status() } },
							--	{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { search, location } },
						})
					end,

					-- Inactive statusline
					inactive = function()
						return MiniStatusline.combine_groups({
							{ hl = "MiniStatuslineInactive", strings = { "%f" } },
						})
					end,
				},

				-- Use default options or customize as needed
				set_vim_settings = true,
			})
		end,
	},
}
