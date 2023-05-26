-- had to add Trouble manually because didn't show up
return {
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")

			wk.setup({
				layout = {
					height = { min = 1 },
					width = { min = 20 },
					spacing = 3, -- spacing between columns
					align = "center", -- align columns left, center or right
				},
				icons = {
					breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
					separator = " ", -- symbol used between a key and it's label
					group = "", -- symbol prepended to a group
				},
			})
			wk.register(
				{
					["<leader>"] = {
						b = {
							name = " Debugging",
							a = { "<cmd>TroubleToggle<cr>", " Toggle Trouble" },
							b = { "<cmd>TroubleRefresh<cr>", " Refresh Trouble" },
						},
						g = { name = " Git" },
						l = { name = " LSP" },
						o = {
							name = "󰮰 Other options",
							l = { "<cmd>Lazy<cr>", "󱒋 Lazy" },
							-- m = { "<cmd>Mason<cr>", "󰕲 Open Mason" },
						},
						s = { name = " Search" },
					},
				}
			)
		end
	}
}
