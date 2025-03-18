return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- import mason
			local mason = require("mason")

			-- import mason-lspconfig
			local mason_lspconfig = require("mason-lspconfig")

			local mason_tool_installer = require("mason-tool-installer")
			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {
					"clangd", -- C/C++
					"neocmake",
					"cssmodules_ls",
					"dockerls",
					"docker_compose_language_service",
					"html",
					"jsonls",
					"ts_ls", -- Javascript
					"ltex",
					"texlab", -- LaTeX
					"lua_ls", -- Lua
					"markdown_oxide",
					"marksman", -- Markdown
					-- "psalm", -- PHP
					"pylsp",
					"ruby_lsp",
					"rust_analyzer", -- RUST
					"sqlls",
					"lemminx", -- XML
					"hydra_lsp", -- YAML
					"bashls", -- Bash
				},
			})
			mason_tool_installer.setup({
				ensure_installed = {
					"clang-format", -- C/C++ formatter_path
					--	"cpplint", -- C/C++ Linter -- removed not very good
					"cmakelang",
					"cmakelint", -- CMake linter
					"bibtex-tidy", -- Bibtex
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint", -- python linter
					"eslint_d", -- js linter
					"hadolint", -- docker linter
					"markdownlint", -- markdown linter
					-- "phpstan", -- PHP linter
					-- "pretty-php", -- PHP Linter
				},
			})
		end,
	},
}
