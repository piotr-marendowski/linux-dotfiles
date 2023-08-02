-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "|" },
					change = { text = "|" },
					delete = { text = "|" },
					topdelete = { text = "|" },
					changedelete = { text = "|" },
					untracked = { text = "|" },
				},
			})
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		commit = "2957f74",
		config = function()
			require("git-conflict").setup({
				default_mappings = {
					ours = "co",
					theirs = "ct",
					none = "c0",
					both = "cb",
					next = "cn",
					prev = "cp",
				},
			})
		end,
	},
    -- Lazygit is in toggleterm.lua
}
