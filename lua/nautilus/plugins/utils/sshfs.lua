return {
	"nosduco/remote-sshfs.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"RemoteSSHFSConnect",
		"RemoteSSHFSDisconnect",
		"RemoteSSHFSFindFiles",
		"RemoteSSHFSLiveGrep",
		"RemoteSSHFSEdit",
	},
	opts = {
		ui = { picker = "snacks" },
		connections = {
			ssh_configs = {
				vim.fn.expand("$HOME") .. "/.ssh/config",
				"/etc/ssh/ssh_config",
			},
			sshfs_args = { "-o reconnect", "-o ConnectTimeout=5" },
		},
		mounts = {
			base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
			unmount_on_exit = true,
		},
		handlers = {
			on_connect = { change_dir = true },
			on_disconnect = { clean_mount_folders = false },
		},
		log = { enabled = false },
	},
	keys = {
		{ "<leader>rc", "<cmd>RemoteSSHFSConnect<CR>",    desc = "[R]emote [C]onnect" },
		{ "<leader>rd", "<cmd>RemoteSSHFSDisconnect<CR>", desc = "[R]emote [D]isconnect" },
		{ "<leader>rf", "<cmd>RemoteSSHFSFindFiles<CR>",  desc = "[R]emote [F]ind files" },
		{ "<leader>rg", "<cmd>RemoteSSHFSLiveGrep<CR>",   desc = "[R]emote [G]rep" },
		{ "<leader>re", "<cmd>RemoteSSHFSEdit<CR>",       desc = "[R]emote [E]dit SSH config" },
	},
}
