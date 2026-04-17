return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			spec = {
				-- ── Navigation prefixes ──────────────────────────────────────
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "z", group = "fold" },
				{ "g", group = "goto / lsp" },

				-- ── <leader> top-level groups ────────────────────────────────
				{
					{ "<leader>a", group = "ai",      icon = { icon = " ", color = "yellow" } },
					{ "<leader>b", group = "buffer",  icon = { icon = "󰈔 ", color = "cyan" } },
					{ "<leader>c", group = "code",    icon = { icon = "󰅪 ", color = "orange" } },
					{ "<leader>d", group = "debug",   icon = { icon = " ", color = "red" } },
					{ "<leader>f", group = "file",    icon = { icon = "󰉋 ", color = "blue" } },
					{ "<leader>g", group = "git",     icon = { icon = "󰊢 ", color = "green" } },
					{ "<leader>m", group = "markdown",icon = { icon = "󰍔 ", color = "cyan" } },
					{ "<leader>o", group = "overseer",icon = { icon = "󰗇 ", color = "orange" } },
					{ "<leader>p", group = "project", icon = { icon = "󰗋 ", color = "purple" } },
					{ "<leader>s", group = "search",  icon = { icon = " ", color = "blue" } },
					{ "<leader>t", group = "test",    icon = { icon = "󰙨 ", color = "green" } },
					{ "<leader>u", group = "ui",      icon = { icon = "󰙵 ", color = "cyan" } },
					{ "<leader>w", group = "window / workspace", icon = { icon = "󱂬 ", color = "azure" } },
				},

				-- ── <leader>g  sub-group ─────────────────────────────────────
				{ "<leader>gh", group = "hunks", icon = { icon = "󰊢 ", color = "green" } },

				-- ── <leader>s  sub-group ─────────────────────────────────────
				{ "<leader>sn", group = "noice", icon = { icon = "󰍡 ", color = "purple" } },

				-- ── Convenience single-key leaves (not groups) ───────────────
				-- <leader>z   → Zen Mode      (defined in snacks.lua)
				-- <leader>Z   → Zoom          (defined in snacks.lua)
				-- <leader>.   → Scratch       (defined in snacks.lua)
				-- <leader>n   → Notif history (defined in snacks.lua)
				-- <leader>N   → Nvim news     (defined in snacks.lua)
			},
		},
		keys = {
			{
				"<leader>?",
				function() require("which-key").show({ global = false }) end,
				desc = "Buffer Keymaps (which-key)",
			},
		},
	},
}
