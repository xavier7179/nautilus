return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
			[[                                                                       ]],
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", " > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC fe", " > Toggle file explorer", "<cmd>Neotree toggle<CR>"),
			dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", " > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯 > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("l", "󰒲 > Lazy", ":Lazy<CR>"),
			dashboard.button("u", " > Update Plugins", "<cmd>lua require('lazy').sync()<CR>"),
			dashboard.button("p", "󱌣 > Update Parsers", ":TSUpdate all<CR>"),
			dashboard.button("m", "󰉼 > Update Mason", ":MasonUpdate<CR>"),
			dashboard.button("h", "󰋠 > Check Health", ":checkhealth<CR>"),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

		local function footer()
			local total_plugins = #require("lazy").plugins()
			local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
			local version = vim.version()
			local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

			return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
		end

		dashboard.section.footer.val = footer()
	end,
}
