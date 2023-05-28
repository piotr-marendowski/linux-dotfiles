return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    build = function()
	require("trouble").setup({
	    mode = "quickfix",
	})
    end,
}
