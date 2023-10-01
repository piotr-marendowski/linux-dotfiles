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
					spacing = 1, -- spacing between columns
					align = "center", -- align columns left, center or right
				},
				icons = {
					breadcrumb = "", -- symbol used in the command line area that shows your active key combo
					separator = "", -- symbol used between a key and it's label
					group = "", -- symbol prepended to a group
				},
				window = {
					border = "single", -- none, single, double, shadow
					position = "bottom", -- bottom, top
					padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
                    margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
					winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
			})
			-- most of the options have keybindings in their respecting files, some don't have them and are here
			wk.register({
				["<leader>"] = {
					t = { "<cmd>TroubleToggle<cr>", " Trouble" },
					c = {
						name = " Code",
					},
					d = {
						name = " Debugging",
					},
					s = {
						name = " Search",
						b = {
							name = " Debugging",
							b = { "<cmd>Telescope dap list_breakpoints<cr>", " Breakpoints" },
							c = { "<cmd>Telescope dap commands<cr>", " Commands" },
							f = { "<cmd>Telescope dap variables<cr>", " Frames" },
							v = { "<cmd>Telescope dap frames<cr>", "󰫧 Variables" },
							s = { "<cmd>Telescope dap configurations<cr>", " Settings" },
						},
					},
					o = {
						name = " Other",
						l = { "<cmd>Lazy<cr>", "󱒋 Lazy" },
						a = { "<cmd>Alpha<cr>", " Alpha" },
					},
					m = {
						name = " Marks",
					},
					p = {
						name = " Sessions",
					},
                    a = {
                        name = "󰔎 Themes",
                        d = { "<cmd>colorscheme tokyonight-day<cr>", " Tokyonight Day"},
                        s = { "<cmd>colorscheme tokyonight-storm<cr>", " Tokyonight Storm"},
                    },
					i = {
						name = " Pomodoro",
					},
				},
			})
		end,
	},
}
