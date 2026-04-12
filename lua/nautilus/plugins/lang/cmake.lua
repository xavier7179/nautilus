local lang = require("nautilus.custom.lang")

return {
	{
		"Civitasv/cmake-tools.nvim",
		lazy = true,
		init = function()
			local loaded = false

			local function check()
				local cwd = vim.uv.cwd()
				if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
					require("lazy").load({ plugins = { "cmake-tools.nvim" } })
					loaded = true
				end
			end

			check()

			vim.api.nvim_create_autocmd("DirChanged", {
				callback = function()
					if not loaded then check() end
				end,
			})
		end,
		opts = {},
		keys = {
			{ "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
			{ "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
			{ "<leader>cr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
			{ "<leader>ct", "<cmd>CMakeRunTest<cr>", desc = "CMake Test" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		ft = lang.ft("cmake"),
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}
			opts.servers.cmake = opts.servers.cmake or {}
			return opts
		end,
	},
}
