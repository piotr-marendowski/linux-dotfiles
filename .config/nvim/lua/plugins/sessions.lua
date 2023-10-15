-- Sessions
return {
    {
        "jedrzejboczar/possession.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("possession").setup({
                autosave = {
                    current = true,
                },
                plugins = {
                    delete_hidden_buffers = false,
                },
            })
        end,
    },
}
