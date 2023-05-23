-- Open on the left side
return {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {},
		config = function()
			require("nvim-tree").setup()
			require("keys").map(
				{ "n", "v" },
				"<leader>e",
				"<cmd>NvimTreeToggle<cr>",
				"Toggle file explorer"
			)
		end,
	},
}

