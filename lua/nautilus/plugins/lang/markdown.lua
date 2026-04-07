return {
	{
		"neovim/nvim-lspconfig",
		ft = { "markdown" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.marksman = {
				filetypes = { "markdown", "md" },
			}

			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters = opts.linters or {}

			opts.linters_by_ft.markdown = { "markdownlint-cli2" }

			opts.linters["markdownlint-cli2"] = vim.tbl_deep_extend("force", opts.linters["markdownlint-cli2"] or {}, {
				args = { "--config", vim.fn.expand("$HOME/.markdownlint-cli2.yaml"), "--" },
			})

			return opts
		end,
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, opts.linters_by_ft or {})
			lint.linters = vim.tbl_deep_extend("force", lint.linters or {}, opts.linters or {})
		end,
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters = opts.formatters or {}

			opts.formatters_by_ft.markdown = { "markdownlint-cli2" }

			opts.formatters["markdownlint-cli2"] =
				vim.tbl_deep_extend("force", opts.formatters["markdownlint-cli2"] or {}, {
					args = { "--config", vim.fn.expand("$HOME/.markdownlint-cli2.yaml"), "--fix", "$FILENAME" },
				})

			return opts
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
		opts = {
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
			checkbox = {
				enabled = false,
			},
			latex = { enabled = false },
			completions = {
				lsp = { enabled = true },
			},
		},
	},

	{
		"chrisgrieser/nvim-origami",
		optional = true,
		ft = { "markdown" },
		opts = {},
	},

	{
		"AckslD/nvim-FeMaco.lua",
		optional = true,
		ft = { "markdown" },
		opts = {},
	},
	{
		"folke/which-key.nvim",
		optional = true,
		ft = { "markdown" },
		opts = function(_, opts)
			opts = opts or {}
			opts.spec = opts.spec or {}
			table.insert(opts.spec, {
				{ "<leader>m", group = "markdown" },
				{
					"<leader>mt",
					function()
						vim.cmd("silent !markdown-toc -i " .. vim.fn.expand("%:p"))
						vim.cmd("edit")
					end,
					desc = "Update Markdown TOC",
				},
			})
			return opts
		end,
	},
}
