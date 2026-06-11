-- LSP configuration with all plugins
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "antosha417/nvim-lsp-file-operations", config = true },
			"mason-org/mason-lspconfig.nvim",
		},
		opts = function()
			local signs = vim.g.have_nerd_font
					and {
						text = {
							[vim.diagnostic.severity.ERROR] = "󰅚 ",
							[vim.diagnostic.severity.WARN] = "󰀪 ",
							[vim.diagnostic.severity.INFO] = "󰋽 ",
							[vim.diagnostic.severity.HINT] = "󰌶 ",
						},
					}
				or {}

			return {
				diagnostics = {
					severity_sort = true,
					float = { border = "rounded", source = "if_many" },
					underline = { severity = vim.diagnostic.severity.ERROR },
					signs = signs,
					virtual_text = {
						source = "if_many",
						spacing = 2,
						format = function(diagnostic)
							local messages = {
								[vim.diagnostic.severity.ERROR] = diagnostic.message,
								[vim.diagnostic.severity.WARN] = diagnostic.message,
								[vim.diagnostic.severity.INFO] = diagnostic.message,
								[vim.diagnostic.severity.HINT] = diagnostic.message,
							}
							return messages[diagnostic.severity]
						end,
					},
				},
				servers = {},
			}
		end,
		config = function(_, opts)
			local mason_lspconfig = require("mason-lspconfig")
			local snacks = require("snacks.picker")
			local inspection_profile = require("nautilus.custom.inspection-profile")

			vim.diagnostic.config(opts.diagnostics)

			local function apply_profile_diagnostics(profile)
				local profile_diags = inspection_profile.diagnostics(profile)
				vim.diagnostic.config(vim.tbl_deep_extend("force", {}, opts.diagnostics or {}, profile_diags or {}))
			end

			apply_profile_diagnostics(inspection_profile.get())
			vim.api.nvim_create_autocmd("User", {
				pattern = inspection_profile.event_name(),
				callback = function(event)
					local profile = event.data and event.data.profile or inspection_profile.get()
					apply_profile_diagnostics(profile)
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

				-- Hover styling: rounded border + capped width, passed directly to buf.hover()
				-- per the Neovim 0.12 deprecation of vim.lsp.with().
				-- Uses "rounded" to match the diagnostic float rather than "single" (blink popup)
				-- since hover and completion are visually distinct surfaces.
				map("K", function()
					vim.lsp.buf.hover({ border = "rounded", max_width = 80, max_height = 20 })
				end, "Hover Documentation")

				map("gR", function() snacks.lsp_references() end, "[G]oto [R]eferences")
				map("gD", function() snacks.lsp_declarations() end, "[G]oto [D]eclaration")
				map("gd", function() snacks.lsp_definitions() end, "[G]oto [D]efinition")
				map("gi", function() snacks.lsp_implementations() end, "[G]oto [I]mplementation")
				map("gt", function() snacks.lsp_type_definitions() end, "[G]oto [T]ype Definition")
				map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("gr", vim.lsp.buf.rename, "[R]e[n]ame")
				map("gl", vim.diagnostic.open_float, "[G]oto f[L]oat Diagnostic")
				map("<leader>ss", function() snacks.lsp_symbols() end, "[S]earch LSP [S]ymbols")
				map("<leader>sS", function() snacks.lsp_workspace_symbols() end, "[S]earch LSP Workspace [S]ymbols")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				
				-- clangd-specific keymap
				if client and client.name == "clangd" then
					map("<leader>ch", function()
						require("clangd_extensions.switch_source_header").switch_source_header()
					end, "[C]lang switch [H]eader/Source")
				end

				if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
					then
					local buf = event.buf
					local highlight_group = vim.api.nvim_create_augroup("LspHighlight_" .. buf, { clear = true })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = buf,
						group = highlight_group,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = buf,
						group = highlight_group,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("LspDetach_" .. buf, { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "LspHighlight_" .. event2.buf, buffer = event2.buf })
						end,
					})
					end
				end,
			})

			mason_lspconfig.setup({
				ensure_installed = {},
				automatic_enable = false,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for server_name, server_opts in pairs(opts.servers or {}) do
				-- Language modules may still contribute server configs that are explicitly disabled.
				-- Keep the config visible, but skip activation at runtime.
				if server_opts.enabled == false then goto continue end

				server_opts.capabilities =
					vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})

				vim.lsp.config(server_name, server_opts)
				vim.lsp.enable(server_name)

				::continue::
			end
		end,
	},
}
