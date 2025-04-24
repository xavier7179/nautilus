return {
    { -- Formatter
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        dependencies = { "mason.nvim" },
        keys = {
            {
                "<leader>fp",
                function()
                    require("conform").format({
                        lsp_fallback = true,
                        async = false,
                        timeout_ms = 500,
                    })
                end,
                mode = { "n", "v" },
                desc = "[F]ile [P]rettier",
            },
        },
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                --			c = { "clang-format" },
                --			cpp = { "clang-format" },
                --					rust = { "rustfmt" },
                --					javascript = { "prettier" },
                --					javascriptreact = { "prettier" },
                --					css = { "prettier" },
                --					html = { "prettier" },
                --					json = { "prettier" },
                --					yaml = { "prettier" },
                lua = { "stylua" },
                sh = { "shfmt" },
                markdown = { "markdownlint-cli2", "markdown-toc" },
                --					python = { "isort", "black" },
                --					bibtex = { "bibtex-tidy" },
                --					docker = { "hadolint" },
                -- php = { "pretty-php", "phpstan" },
                php = { "php_cs_fixer" },
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function()
            local conform = require("conform")

            conform.setup({
                format_on_save = function(bufnr)
                    -- Disable with a global or buffer-local variable
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return { timeout_ms = 1000, async = false, lsp_format = "fallback" }
                end,
            })
        end,
    },
}
