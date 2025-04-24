return {
    {
        "preservim/vim-pencil",
        lazy = true,
        ft = { "plaintex", "markdown", "tex" },
        init = function()
            vim.g["pencil#wrapModeDefault"] = "soft"
        end,

    } }
