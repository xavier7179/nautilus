return {
	bash = {
		ft = { "sh", "bash", "zsh" },
		treesitter = { "bash" },
		services = {
			lsp = {
				enabled = true,
				servers = { "bashls" },
				mason = { "bashls" },
			},
			format = {
				enabled = true,
				conform = { "shfmt" },
				mason = { "shfmt" },
			},
			lint = {
				enabled = true,
				linters = { "shellcheck" },
				mason = { "shellcheck" },
			},
			dap = {
				enabled = true,
				mason = { "bash-debug-adapter" },
			},
			completion = {
				enabled = true,
			},
		},
	},

	c = {
		ft = { "c", "cpp" },
		treesitter = { "c", "cpp", "diff" },
		services = {
			lsp = {
				enabled = true,
				servers = { "clangd" },
				mason = { "clangd" },
			},
			format = {
				enabled = true,
				conform = { "clang_format" },
				mason = { "clang-format" },
			},
			lint = {
				enabled = false,
				linters = {},
				mason = {},
			},
			dap = {
				enabled = true,
				mason = { "codelldb" },
			},
			completion = {
				enabled = true,
			},
		},
	},

	cmake = {
		ft = { "cmake" },
		treesitter = { "cmake" },
		services = {
			lsp = {
				enabled = true,
				servers = { "cmake" },
				mason = { "cmake-language-server" },
			},
			format = {
				enabled = false,
				conform = {},
				mason = {},
			},
			lint = {
				enabled = true,
				linters = { "cmakelint" },
				mason = {},
			},
			dap = {
				enabled = false,
				mason = {},
			},
			completion = {
				enabled = true,
			},
		},
	},

	javascript = {
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		treesitter = { "javascript", "typescript", "tsx", "jsdoc", "css", "html" },
		services = {
			lsp = {
				enabled = true,
				servers = { "vtsls" },
				mason = { "vtsls" },
			},
			format = {
				enabled = true,
				conform = { "biome" },
				mason = { "biome" },
			},
			lint = {
				enabled = true,
				linters = { "eslint" },
				mason = { "eslint-lsp" },
			},
			dap = {
				enabled = true,
				mason = { "js-debug-adapter" },
			},
			completion = {
				enabled = true,
			},
		},
	},

	lua = {
		ft = { "lua" },
		treesitter = { "lua", "luadoc", "luap", "printf", "query", "vim", "vimdoc" },
		services = {
			lsp = {
				enabled = true,
				servers = { "lua_ls" },
				mason = { "lua_ls" },
			},
			format = {
				enabled = true,
				conform = { "stylua" },
				mason = { "stylua" },
			},
			lint = {
				enabled = false,
				linters = {},
				mason = {},
			},
			dap = {
				enabled = false,
				mason = {},
			},
			completion = {
				enabled = true,
			},
		},
	},

	markdown = {
		ft = { "markdown", "md" },
		treesitter = { "markdown", "markdown_inline", "comment", "regex" },
		services = {
			lsp = {
				enabled = true,
				servers = { "marksman" },
				mason = { "marksman" },
			},
			format = {
				enabled = true,
				conform = { "markdownlint-cli2", "markdown-toc" },
				mason = { "markdownlint-cli2", "markdown-toc" },
			},
			lint = {
				enabled = true,
				linters = { "markdownlint-cli2" },
				mason = { "markdownlint" },
			},
			dap = {
				enabled = false,
				mason = {},
			},
			completion = {
				enabled = true,
			},
		},
	},

	php = {
		ft = { "php" },
		treesitter = { "php" },
		services = {
			lsp = {
				enabled = true,
				servers = { "intelephense" },
				mason = { "intelephense" },
			},
			format = {
				enabled = true,
				conform = { "php_cs_fixer" },
				mason = { "php-cs-fixer" },
			},
			lint = {
				enabled = true,
				linters = { "phpcs" },
				mason = { "phpcs" },
			},
			dap = {
				enabled = true,
				mason = { "php-debug-adapter" },
			},
			completion = {
				enabled = true,
			},
		},
	},

	rust = {
		ft = { "rust" },
		treesitter = { "rust", "ron" },
		services = {
			lsp = {
				enabled = true,
				servers = { "bacon_ls" },
				mason = { "bacon-ls" },
			},
			format = {
				enabled = true,
				conform = { "rustfmt" },
				mason = {},
			},
			lint = {
				enabled = true,
				linters = {},
				mason = { "bacon" },
			},
			dap = {
				enabled = true,
				mason = { "codelldb" },
			},
			completion = {
				enabled = true,
			},
		},
	},

	yaml = {
		ft = { "yaml" },
		treesitter = { "yaml" },
		services = {
			lsp = {
				enabled = true,
				servers = { "yamlls" },
				mason = { "yamlls" },
			},
			format = {
				enabled = false,
				conform = {},
				mason = {},
			},
			lint = {
				enabled = true,
				linters = { "yamllint" },
				mason = { "yamllint" },
			},
			dap = {
				enabled = false,
				mason = {},
			},
			completion = {
				enabled = true,
			},
		},
	},
}
