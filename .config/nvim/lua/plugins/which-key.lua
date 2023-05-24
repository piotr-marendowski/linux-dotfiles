-- had to add Trouble manually because didn't show up
return {
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.setup({
				icons = {
					breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
					separator = " ", -- symbol used between a key and it's label
					group = " ", -- symbol prepended to a group
				},
			})
			wk.register(
				{
					["<leader>"] = {
						f = { name = "File" },
						d = { name = "Delete/Close" },
						q = { name = "Quit" },
						s = { name = "Search" },
						l = { name = "LSP" },
						t = {
							name = "Trouble",
							a = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
							b = { "<cmd>TroubleRefresh<cr>", "Refresh Trouble" },
						},
						b = { name = "Debugging" },
						g = { name = "Git" },
					}
				}
			)
		end
	}
}
