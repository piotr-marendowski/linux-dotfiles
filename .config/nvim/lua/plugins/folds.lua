-- zc => close fold
-- zo => open fold
-- za => toggle fold
-- on folded line h => preview
-- on folded line l => open
return {
    {
        "anuvyklack/pretty-fold.nvim",
        config = function()
            require("pretty-fold").setup({
                fill_char = " ",
            })
        end,
    },
    {
        "anuvyklack/fold-preview.nvim",
        dependencies = {
            "anuvyklack/keymap-amend.nvim",
        },
        config = function()
            require("fold-preview").setup()
        end,
    },
}
