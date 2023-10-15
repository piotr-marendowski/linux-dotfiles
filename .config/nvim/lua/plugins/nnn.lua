-- use nnn file manager
return {
    "luukvbaal/nnn.nvim",
    event = "VeryLazy",
    config = function()
        require("nnn").setup({
            picker = {
                cmd = "nnn -edH",
                style = {
                    -- percentage relative to terminal size when < 1, absolute otherwise
                    width = 100,
                    height = 0.7,
                    xoffset = 0.5,
                    yoffset = 0.5,
                    -- border decoration for example "rounded"(:h nvim_open_win)
                    border = "single"
                },
            }
        })
        -- run in floating window with cwd
        local map = require("keys").map
        map("n", "<leader>e", '<cmd>NnnPicker %:p:h<cr>', " File manager")
    end
}
