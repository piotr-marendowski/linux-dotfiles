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
					width = { min = 1, max = 100 },
					spacing = 2, -- spacing between columns
					align = "center", -- align columns left, center or right
				},
				icons = {
					breadcrumb = "", -- symbol used in the command line area that shows your active key combo
					separator = "", -- symbol used between a key and it's label
					group = "", -- symbol prepended to a group
				},
				window = {
					border = "single", -- none, single, double, shadow
					position = "top", -- bottom, top
					padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
                    margin = { 14, 55, 0, 55 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
					winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
			})
			-- most of the options have keybindings in their respecting files, some don't have them and are here
			wk.register({
				["<leader>"] = {
					c = {
						name = " Code related",
					},
					b = {
						name = " Debugging        ",
						a = { "<cmd>TroubleToggle<cr>", " Toggle Trouble" },
					},
					s = {
						name = " Search",
						b = {
							name = " Debugging",
							b = { "<cmd>Telescope dap list_breakpoints<cr>", " Breakpoints     " },
							c = { "<cmd>Telescope dap commands<cr>", " Commands" },
							f = { "<cmd>Telescope dap variables<cr>", " Frames" },
							v = { "<cmd>Telescope dap frames<cr>", "󰫧 Variables" },
							s = { "<cmd>Telescope dap configurations<cr>", " Settings" },
						},
					},
					o = {
						name = "󰮰 Other actions",
						l = { "<cmd>Lazy<cr>", "󱒋 Lazy             " },
						a = { "<cmd>NvimTreeClose | Alpha<cr>", " Alpha" },
					},
					m = {
						name = " Marks",
					},
					t = {
						name = "  Toggle",
					},
					p = {
						name = " Sessions",
					},
				},
			})
		end,
	},
}
