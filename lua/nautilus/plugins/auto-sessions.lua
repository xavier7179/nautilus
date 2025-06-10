return {
	"rmagatti/auto-session",
	lazy = true,
	keys = {
		-- Will use Telescope if installed or a vim.ui.select picker otherwise
		{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
		{ "<leader>wl", "<cmd>SessionRestore<CR>", desc = "Restore last session" },
		{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
		{ "<leader>uS", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
	},
	opts = {
		suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
		log_level = "error",
		auto_restore = false,
		use_git_branch = false, -- Include git branch name in session name
	},
}
