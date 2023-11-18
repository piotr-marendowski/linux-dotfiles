return {
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({
                default_mappings = false,
                mappings = {
                    set_next = "m;",
                    next = "mk",
                    preview = "m:",
                    prev = "mj",
                    delete = "dm",
                    delete_buf = "dm;",
                }
            })
        end
    }
}
