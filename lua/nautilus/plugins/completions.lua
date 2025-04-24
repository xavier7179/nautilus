-- Completions Support for all possibile languages here
return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "LazyVim",            words = { "LazyVim" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
                { path = "lazy.nvim",          words = { "LazyVim" } },
            },
        },
    },
    --{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {            -- This includes the previous packages
            "hrsh7th/cmp-buffer",   -- source for text in buffer
            "hrsh7th/cmp-path",     -- source for file system paths
            "onsails/lspkind.nvim", -- vs-code like pictograms
        },
        config = function()
            -- Set up nvim-cmp.
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local lspkind = require("lspkind")

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    {
                        name = "lazydev",
                        group_index = 0,  -- set group index to 0 to skip loading LuaLS completions
                    },
                    { name = "luasnip" }, -- For luasnip users.
                    { name = "buffer" },  -- text within current buffer
                    { name = "path" },    -- file system paths
                }),
                -- configure lspkind for vs-code like pictograms in completion menu
                formatting = {
                    format = function(entry, item)
                        local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
                        item = require("lspkind").cmp_format({

                            mode = "symbol", -- show only symbol annotations
                            maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                            -- can also be a function to dynamically calculate max width such as
                            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                            ellipsis_char = "...",    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
                        })(entry, item)
                        if color_item.abbr_hl_group then
                            item.kind_hl_group = color_item.abbr_hl_group
                            item.kind = color_item.abbr
                        end
                        return item
                    end,
                },
            })
        end,
    },
    { -- Closing brackets with nvim-cmp
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            -- import nvim-autopairs
            local autopairs = require("nvim-autopairs")

            -- configure autopairs
            autopairs.setup({
                check_ts = true,                        -- enable treesitter
                ts_config = {
                    lua = { "string" },                 -- don't add pairs in lua string treesitter nodes
                    javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
                    java = false,                       -- don't check treesitter on java
                },
            })

            -- import nvim-autopairs completion functionality
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            -- import nvim-cmp plugin (completions plugin)
            local cmp = require("cmp")

            -- make autopairs and completion work together
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
