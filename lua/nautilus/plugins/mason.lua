return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        dependencies = {
            "williamboman/mason.nvim",
            --    "mfussenegger/nvim-dap",
        },
    },
    "williamboman/mason-lspconfig.nvim",
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
        config = function(_, opts)
            -- import mason
            local mason = require("mason")
            mason.setup(opts)
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
            ensure_installed = {
                -- LSP Config Section
                "clangd",             -- C/C++
                "lua_ls",             -- Lua
                "marksman",           -- Markdown
                "phpactor",           -- PHP
                "bashls",             -- Bash
                -- Linters and Formatters
                "shellcheck",         -- bash linter
                "clang-format",       -- C/C++ formatter_path
                "stylua",             -- lua formatter
                "shfmt",              -- shell formatter
                "markdownlint-cli2",  -- markdown formatter
                "markdown-toc",       -- mardown formatter
                "markdownlint",       -- markdown linter
                "phpcs",              -- PHP linter
                "php-cs-fixer",       -- PHP formatter
                -- DAP
                "bash-debug-adapter", -- Bash
                "codelldb",           -- C /CPP / Rust
                "php-debug-adapter",  -- PHP

            }
        }
    }
}
