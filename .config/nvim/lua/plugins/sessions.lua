return {
    {
        "piotr-marendowski/possession.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("possession").setup({
                autosave = {
                    current = true,
                },
                plugins = {
                    delete_hidden_buffers = false,
                },
                telescope = {
                    previewer = nil,
                }
            })

            vim.opt.sessionoptions = "buffers,terminal"
            -- vim.opt.sessionoptions = "blank,buffers,curdir,help,tabpages,globals,winsize,winpos,terminal,folds"
            -- vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufWinEnter" }, {
            --     group = vim.api.nvim_create_augroup("ts_fold_workaround", { clear = true }),
            --     command = "set foldexpr=nvim_treesitter#foldexpr()",
            -- })
        end,
    },
}
