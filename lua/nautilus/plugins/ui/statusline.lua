return {
	{
		"echasnovski/mini.statusline",
		version = "*",
		opts = {
			use_icons = vim.g.have_nerd_font,
		},
		config = function(_, opts)
			-- LSP progress: cache the latest message so the statusline can poll it.
			local lsp_progress_msg = ""
			vim.api.nvim_create_autocmd("LspProgress", {
				desc = "Cache LSP progress for statusline",
				callback = function(args)
					local value = args.data and args.data.params and args.data.params.value
					if not value then
						lsp_progress_msg = ""
						return
					end
					if value.kind == "end" then
						lsp_progress_msg = ""
					else
						local title = value.title or ""
						local msg   = value.message or ""
						local pct   = value.percentage
						lsp_progress_msg = pct
							and ("%s %s (%d%%)"):format(title, msg, pct)
							or  ("%s %s"):format(title, msg)
						lsp_progress_msg = lsp_progress_msg:gsub("^%s+", ""):gsub("%s+$", "")
					end
				end,
			})

			require("mini.statusline").setup(vim.tbl_deep_extend("force", {
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git           = MiniStatusline.section_git({ trunc_width = 40 })
						local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
						local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location      = MiniStatusline.section_location({ trunc_width = 75 })
						local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

						-- Macro recording indicator
						local recording = ""
						local reg = vim.fn.reg_recording()
						if reg ~= "" then recording = ("  @%s"):format(reg) end

						-- LSP progress (shows indexing/loading status)
						local progress = lsp_progress_msg ~= "" and (" " .. lsp_progress_msg) or ""

						-- Lazy pending updates
						local lazy_status  = require("lazy.status")
						local lazy_updates = lazy_status.has_updates()
							and ("Lazy: %s"):format(lazy_status.updates())
							or  ""

						return MiniStatusline.combine_groups({
							{ hl = mode_hl,                   strings = { mode, recording } },
							{ hl = "MiniStatuslineDevinfo",   strings = { git, lazy_updates, diagnostics, lsp } },
							{ hl = "MiniStatuslineFilename",  strings = { progress } },
							"%<", -- truncate point
							"%=", -- right-align from here
							{ hl = "MiniStatuslineFileinfo",  strings = { fileinfo } },
							{ hl = mode_hl,                   strings = { search, location } },
						})
					end,

					inactive = function()
						return MiniStatusline.combine_groups({
							{ hl = "MiniStatuslineInactive", strings = { "%f" } },
						})
					end,
				},
				set_vim_settings = true,
			}, opts))
		end,
	},
}

