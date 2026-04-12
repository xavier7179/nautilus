local lang = require("nautilus.custom.lang")

return {
	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("markdown"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.marksman = vim.tbl_deep_extend("force", opts.servers.marksman or {}, {
				filetypes = lang.ft("markdown"),
			})

			return opts
		end,
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
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
			latex = {
				enabled = false,
			},
			completions = {
				lsp = {
					enabled = true,
				},
			},
		},
	},

	{
		"chrisgrieser/nvim-origami",
		optional = true,
		ft = lang.ft("markdown"),
		opts = {},
	},

	{
		"AckslD/nvim-FeMaco.lua",
		optional = true,
		ft = lang.ft("markdown"),
		opts = {},
	},

	{
		"folke/which-key.nvim",
		optional = true,
		ft = lang.ft("markdown"),
		opts = function(_, opts)
			opts = opts or {}
			opts.spec = opts.spec or {}

			table.insert(opts.spec, { "<leader>m", group = "markdown" })
			table.insert(opts.spec, {
				"<leader>mt",
				function()
					vim.cmd("silent !markdown-toc -i " .. vim.fn.expand("%:p"))
					vim.cmd("edit")
				end,
				desc = "Update Markdown TOC",
			})

			return opts
		end,
	},
}
