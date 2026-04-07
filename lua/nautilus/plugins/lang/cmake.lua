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
		ft = { "cmake" },
		opts = function(_, opts)
			opts = opts or {}
			opts.servers = opts.servers or {}

			opts.servers.cmake = {}

			return opts
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			opts.linters_by_ft.cmake = { "cmakelint" }
			return opts
		end,
	},
}
