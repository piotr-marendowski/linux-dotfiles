return {
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require('alpha')
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				[[                                                  ]],
				[[                                                  ]],
				[[                                                  ]],
				[[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
				[[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
				[[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
				[[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
				[[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
			    [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				[[            The best editor out there!            ]],
				[[                                                  ]],
				[[                                                  ]],
				[[                                                  ]],
			}

			dashboard.section.buttons.val = {
				dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", "󰱓  Find project", ":Telescope projects <CR>"),
				dashboard.button("r", "󰄉  Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "󰊄  Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
				dashboard.button("q", "󰗼  Quit Neovim", ":qa<CR>"),
			}

			-- map these onto which-key
			local map = require("keys").map
			-- map("n", "<leader>af", ":Telescope find_files <CR>", "󰈞 Find file")
			map("n", "<leader>on", ":ene <BAR> startinsert <CR>", " New file")
			map("n", "<leader>sp", ":Telescope projects <CR>", "󰱓 Find project")
			map("n", "<leader>su", ":Telescope oldfiles <CR>", "󰄉 Recently used files")
			-- map("n", "<leader>at", ":Telescope live_grep <CR>", "󰊄 Find text")
			map("n", "<leader>oc", ":e ~/.config/nvim/init.lua <CR>", " Configuration")

			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"
			dashboard.opts.opts.noautocmd = true
			-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
			alpha.setup(dashboard.opts)
		end,
		dependencies = "nvim-tree/nvim-web-devicons",
	},
}

