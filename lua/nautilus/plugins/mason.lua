return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			automatic_installation = false,
			ensure_installed = {},
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
	},

	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts) require("mason").setup(opts) end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- LSP Config Section
				"bacon-ls", -- RUST
				"rust_analyzer", -- RUST
				"clangd", -- C/C++
				"lua_ls", -- Lua
				"marksman", -- Markdown
				"intelephense", -- PHP
				"bashls", -- Bash
				"cmake-language-server", -- CMAKE
				"vtsls", -- TS/JS
				-- Linters and Formatters
				"shellcheck", -- bash linter
				"clang-format", -- C/C++ formatter_path
				"stylua", -- lua formatter
				"shfmt", -- shell formatter
				"markdownlint-cli2", -- markdown formatter
				"markdown-toc", -- mardown formatter
				"markdownlint", -- markdown linter
				"phpcs", -- PHP linter
				"php-cs-fixer", -- PHP formatter
				"eslint-lsp", -- JS linter
				"biome", -- JS formatter
				-- DAP
				"bash-debug-adapter", -- Bash
				"codelldb", -- C /CPP / Rust
				"php-debug-adapter", -- PHP
				"js-debug-adapter", -- TS/JS
				"yamlls", -- YAML LSP
				"yamllint", -- YAML Linter
			},
		},
	},
}
