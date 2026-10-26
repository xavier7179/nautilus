local lang = require("nautilus.custom.lang")

local function lsp_format_for(bufnr)
	return vim.bo[bufnr].filetype == "php" and "never" or "fallback"
end

return {
	-- Formatters
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					lsp_format = lsp_format_for(vim.api.nvim_get_current_buf()),
					async = false,
					timeout_ms = 1000,
				})
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
		},
		opts = function()
			return {
				formatters_by_ft = lang.conform_by_ft(),
				formatters = {},
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
					return {
						timeout_ms = 1000,
						async = false,
						lsp_format = lsp_format_for(bufnr),
					}
				end,
			}
		end,
		init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
	},
	-- Linters
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		opts = function()
			return {
				linters_by_ft = lang.linters_by_ft(),
			}
		end,
		config = function(_, opts)
			local lint = require("lint")
			local inspection_profile = require("nautilus.custom.inspection-profile")

			lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft or {})

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			local eslint_config_files = {
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				".eslintrc",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.json",
				".eslintrc.yaml",
				".eslintrc.yml",
			}

			local function can_lint(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) then return false end
				if vim.bo[bufnr].buftype ~= "" then return false end
				if not vim.bo[bufnr].modifiable then return false end
				if vim.bo[bufnr].filetype == "" then return false end
				return true
			end

			local function do_lint(args)
				local bufnr = args.buf
				if not can_lint(bufnr) then return end
				-- Run from the project root holding the ESLint flat/legacy config so the
				-- project's own rules and node_modules/.bin/eslint are used regardless of
				-- Neovim's cwd (nvim-lint defaults to getcwd()).
				local root = vim.fs.root(bufnr, eslint_config_files)
				lint.try_lint(nil, root and { cwd = root } or nil)
			end

			local function should_lint(event)
				local events = inspection_profile.lint_events()
				return events[event] == true
			end

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lint_augroup,
				callback = function(args)
					if should_lint("BufWritePost") then do_lint(args) end
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				group = lint_augroup,
				callback = function(args)
					if should_lint("InsertLeave") and vim.bo[args.buf].modified then do_lint(args) end
				end,
			})

			vim.api.nvim_create_autocmd("BufEnter", {
				group = lint_augroup,
				callback = function(args)
					if should_lint("BufEnter") then do_lint(args) end
				end,
			})

			--			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			--				group = lint_augroup,
			--				callback = function()
			--					if vim.bo.modifiable then lint.try_lint() end
			--				end,
			--			})
		end,
	},

	--{
	--	"nvimdev/guard.nvim",
	--	ft = { "c", "cpp" },
	--	dependencies = {
	--		"nvimdev/guard-collection",
	--	},
	-- },
}
