-- Sessions
return {
    "Shatur/neovim-session-manager",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    lazy = false,
    config = function()
        require('session_manager').setup({
            autoload_mode = "Disabled",
        })

        local map = require("keys").map
        map("n", "<leader>pl", '<cmd>SessionManager load_session<cr>', " List sessions")
        map("n", "<leader>pn", '<cmd>SessionManager save_current_session<cr>', " New session")
        map("n", "<leader>pd", '<cmd>SessionManager delete_session<cr>', "󰺝 Delete")
    end,
}
