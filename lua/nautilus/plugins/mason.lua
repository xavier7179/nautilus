return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        --       event = "VeryLazy",
        -- cmd = { "DapInstall", "DapUninstall" },
        -- dependencies = {
        --    "williamboman/mason.nvim",
        --    "mfussenegger/nvim-dap",
        -- },
    },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
        "williamboman/mason.nvim",
        config = function()
            -- import mason
            local mason = require("mason")

            -- import mason-lspconfig
            local mason_lspconfig = require("mason-lspconfig")
            local mason_nvim_dap = require("mason-nvim-dap")
            local mason_tool_installer = require("mason-tool-installer")
            mason.setup()
            mason_lspconfig.setup({
                automatic_installation = true,
                ensure_installed = {
                    "clangd", -- C/C++
                    --					"neocmake",
                    --					"cssmodules_ls",
                    --					"dockerls",
                    --					"docker_compose_language_service",
                    --					"html",
                    --					"jsonls",
                    --					"ts_ls", -- Javascript
                    --					"ltex",
                    --					"texlab", -- LaTeX
                    "lua_ls",   -- Lua
                    "marksman", -- Markdown
                    "phpactor", -- PHP
                    -- "pylsp",
                    --					"ruby_lsp",
                    --					"sqlls",
                    --					"lemminx", -- XML
                    --					"hydra_lsp", -- YAML
                    "bashls", -- Bash
                },
            })
            mason_tool_installer.setup({
                auto_update = false,
                ensure_installed = {
                    "clang-format", -- C/C++ formatter_path
                    --	"cpplint", -- C/C++ Linter -- removed not very good
                    --					"cmakelang",
                    --					"cmakelint", -- CMake linter
                    --					"bibtex-tidy", -- Bibtex
                    --					"prettier", -- prettier formatter
                    "stylua", -- lua formatter
                    "shfmt",  -- shell formatter
                    --					"isort", -- python formatter
                    --					"black", -- python formatter
                    --					"pylint", -- python linter
                    --					"eslint_d", -- js linter
                    --					"hadolint", -- docker linter
                    "markdownlint-cli2", -- markdown formatter
                    "markdown-toc",      -- mardown formatter
                    "markdownlint",      -- markdown linter
                    "phpcs",             -- PHP linter
                    "php-cs-fixer",      -- PHP formatter
                },
                integrations = {
                    ['mason-lspconfig'] = true,
                    ['mason-null-ls'] = false,
                    ['mason-nvim-dap'] = true,
                },
            })
            mason_nvim_dap.setup({
                automatic_installation = true,
                ensure_installed = {
                    "codelldb", -- C /CPP / Rust
                    "php"       -- php-debug-adapter -- PHP
                },
            })
        end,
    },
}
