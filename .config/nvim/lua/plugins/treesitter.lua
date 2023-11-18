return {
	"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter.configs").setup({
            enable = true, -- false will disable the whole extension
            ignore_install = { "help" },
            ensure_installed = { "c", "cpp", "lua", "java", "python" },
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
	end
}
