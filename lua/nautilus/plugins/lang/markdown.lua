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
			opts.formatters = opts.formatters or {}
			opts.formatters["markdownlint-cli2"] =
				vim.tbl_deep_extend("force", opts.formatters["markdownlint-cli2"] or {}, {
					args = function()
						-- Use a custom markdownlint config if present, otherwise fall back
						-- to markdownlint-cli2 defaults (which already use 2-space indent).
						local config = vim.fn.expand("$HOME/.markdownlint-cli2.yaml")
						if vim.fn.filereadable(config) == 1 then return { "--config", config, "--fix", "$FILENAME" } end
						return { "--fix", "$FILENAME" }
					end,
					-- args = { "--config", vim.fn.expand("$HOME/.markdownlint-cli2.yaml"), "--fix", "$FILENAME" },
				})

			return opts
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		ft = { "markdown", "norg", "rmd", "org", "codecompanion_chat" },
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
		"AckslD/nvim-FeMaco.lua",
		ft = lang.ft("markdown"),
		opts = {},
		keys = {
			{
				"<leader>me",
				function() require("femaco.edit").edit_code_block() end,
				desc = "Edit fenced code block",
				ft = "markdown",
			},
		},
	},

	{
		"folke/which-key.nvim",
		optional = true,
		ft = lang.ft("markdown"),
		opts = function(_, opts)
			opts = opts or {}
			opts.spec = opts.spec or {}

			-- <leader>m group is declared globally in which-key.lua;
			-- only the markdown-specific keymap is injected here.
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
