-- Language capability registry
--
-- Notes:
-- - Services may stay fully configured even when `enabled = false`
-- - This is intentional for readability and future activation
-- - Runtime/plugin consumers must go through `nautilus.custom.lang`
--   which filters disabled services out unless raw access is requested
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
			tests = {
				enabled = false,
				adapters = {},
			},
			tasks = {
				enabled = false,
				commands = {},
			},
		},
	},

	c = {
		ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		treesitter = { "c", "cpp", "cuda", "proto" },
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
			tests = {
				enabled = false,
				adapters = {},
			},
			tasks = {
				enabled = false,
				commands = {},
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
			tests = {
				enabled = false,
				adapters = {},
			},
			tasks = {
				enabled = true,
				commands = {
					configure = { "cmake", "-S", ".", "-B", "build" },
					build = { "cmake", "--build", "build" },
					test = { "ctest", "--test-dir", "build", "--output-on-failure" },
				},
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
			tests = {
				enabled = true,
				adapters = { "vitest" },
			},
			tasks = {
				enabled = true,
				commands = {
					test = { "npm", "test" },
					build = { "npm", "run", "build" },
					dev = { "npm", "run", "dev" },
				},
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
			tests = {
				enabled = false,
				adapters = { "plenary" },
			},
			tasks = {
				enabled = false,
				commands = {},
			},
		},
	},

	markdown = {
		ft = { "markdown" },
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
			tests = {
				enabled = false,
				adapters = {},
			},
			tasks = {
				enabled = false,
				commands = {},
			},
		},
	},

	php = {
		ft = { "php" },
		treesitter = { "php", "phpdoc" },
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
			tests = {
				enabled = true,
				adapters = { "phpunit" },
			},
			tasks = {
				enabled = true,
				commands = {
					test = { "composer", "test" },
					lint = { "vendor/bin/phpcs" },
					fix = { "vendor/bin/php-cs-fixer", "fix" },
				},
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
			tests = {
				enabled = true,
				adapters = { "rust" },
			},
			tasks = {
				enabled = true,
				commands = {
					test = { "cargo", "test" },
					build = { "cargo", "build" },
					run = { "cargo", "run" },
				},
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
			tests = {
				enabled = false,
				adapters = {},
			},
			tasks = {
				enabled = false,
				commands = {},
			},
		},
	},
}
