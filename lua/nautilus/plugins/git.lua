return {
	{ -- Git Signs
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			attach_to_untracked = false,
			current_line_blame = false,
			sign_priority = 6,
			update_debounce = 200,
			on_attach = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

				-- Navigation
			map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
			map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")

				-- Actions  (<leader>gh = git hunks)
				map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
				map(
					"v",
					"<leader>ghs",
					function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					"Stage hunk"
				)
				map(
					"v",
					"<leader>ghr",
					function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					"Reset hunk"
				)

				map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")

				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")

				map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")

				map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
				map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle line blame")

				map("n", "<leader>ghd", gs.diffthis, "Diff this")
				map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
			end,
		},
	},
	{ -- Diffview
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
		},
		opts = {},
	},
	{ -- Fugit2
		"SuperBo/fugit2.nvim",
		build = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			{ "sindrets/diffview.nvim", optional = true },
		},
		cmd = { "Fugit2", "Fugit2Blame", "Fugit2Diff", "Fugit2Graph", "Fugit2Rebase" },
		keys = {
			{ "<leader>gc", "<cmd>Fugit2<cr>", desc = "Fugit2 Commit Panel" },
		},
		opts = {
			width = 100,
			external_diffview = true, -- use diffview.nvim for diff splits
		},
	},
}
