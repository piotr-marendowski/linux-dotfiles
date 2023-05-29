-- had to add Trouble manually because didn't show up
return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")

			wk.setup({
				layout = {
					height = { min = 1, max = 100 },
					width = { min = 3, max = 50 },
					spacing = 3, -- spacing between columns
					align = "right", -- align columns left, center or right
				},
				icons = {
					breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
					separator = " ", -- symbol used between a key and it's label
					group = "", -- symbol prepended to a group
				},
				window = {
					border = "none", -- none, single, double, shadow
					position = "bottom", -- bottom, top
					margin = { 1, 0, 1, 105 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
					padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
					winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
			})
			-- most of the options have keybindings in their respecting files, some don't have them and are here
			wk.register(
				{
					["<leader>"] = {
						b = {
							name = " Debugging",
							a = { "<cmd>TroubleToggle<cr>", " Toggle Trouble" },
						},
						g = { name = " Git" },
						l = { name = " LSP" },
						s = {
                            name = " Search",
                            b = {
                                name = " Debugging",
                                b = { "<cmd>Telescope dap list_breakpoints<cr>", " Breakpoints"},
                                c = { "<cmd>Telescope dap commands<cr>", " Commands"},
                                f = { "<cmd>Telescope dap variables<cr>", " Frames"},
                                v = { "<cmd>Telescope dap frames<cr>", "󰫧 Variables"},
                                s = { "<cmd>Telescope dap configurations<cr>", " Settings"},
                            }
                        },
						o = {
							name = "󰮰 Other actions",
							l = { "<cmd>Lazy<cr>", "󱒋 Lazy" },
							a = { "<cmd>NvimTreeClose | Alpha<cr>", " Alpha" },
						},
					},
				}
			)
		end
	}
}
