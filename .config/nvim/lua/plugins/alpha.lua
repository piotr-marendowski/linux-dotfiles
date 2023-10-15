return {
	{
		"goolord/alpha-nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VimEnter",
		config = function()
			-- hide bufferline in alpha
			vim.cmd("autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2")

			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- on startup choose one of them
			local header_one = {
				[[                                                  ]],
				[[                                                  ]],
				[[                                                  ]],
				[[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
				[[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
				[[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
				[[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
				[[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
				[[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				[[            The worst editor out there!           ]],
				[[                                                  ]],
				[[                                                  ]],
				[[                                                  ]],
			}
			local header_two = {
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

			local headers = { header_one, header_two }
			local function header_chars()
				math.randomseed(os.time())
				return headers[math.random(#headers)]
			end
			dashboard.section.header.val = header_chars()

			-- buttons
			dashboard.section.buttons.val = {
				dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
				dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("p", "󰱓  Projects", ":Telescope projects <CR>"),
				dashboard.button("s", "  Sessions", ":Telescope possession list<cr>"),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
				dashboard.button("q", "󰗼  Quit", ":qa!<CR>"),
                -- Sessions
				(function()
					local group = { type = "group", opts = { spacing = 0 } }
					group.val = {
						{
							type = "text",
							val = "Sessions",
							opts = {
								position = "center",
							},
						},
					}
					local path = vim.fn.stdpath("data") .. "/possession"
					local files = vim.split(vim.fn.glob(path .. "/*.json"), "\n")
					for i, file in pairs(files) do
						local basename = vim.fs.basename(file):gsub("%.json", "")
						local button = dashboard.button(
							tostring(i),
							"󰑐  " .. basename,
							"<cmd>PossessionLoad " .. basename .. "<cr>"
						)
						table.insert(group.val, button)
					end
					return group
				end)(),
			}

			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"
			dashboard.opts.opts.noautocmd = true
			-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
			alpha.setup(dashboard.opts)

			-- display number of plugins and their loading time
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					local footer = plugins .. "\n"
					dashboard.section.footer.val = footer
					pcall(vim.cmd.AlphaRedraw)
				end,
			})

			-- color footer
			vim.cmd("highlight AlphaFooter ctermfg=15 ctermbg=0")
			dashboard.section.footer.opts.hl = "AlphaFooter"

			-- when closing the last buffer -> go to the alpha
			local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				pattern = "BDeletePost*",
				group = alpha_on_empty,
				callback = function(event)
					local fallback_name = vim.api.nvim_buf_get_name(event.buf)
					local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
					local fallback_on_empty = fallback_name == "" and fallback_ft == ""

					if fallback_on_empty then
						vim.cmd("Alpha")
						vim.cmd(event.buf .. "bwipeout")
					end
				end,
			})
		end,
	},
}
