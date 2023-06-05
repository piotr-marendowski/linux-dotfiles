-- Notifications, better cmdline stuff, upgrades to UI
return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			{
                "rcarriga/nvim-notify",
                opts = {
                    minimum_width = 20,
                    max_width = 40,
                    max_height = 10,
                    stages = "fade",
                    timeout = 2000,
                }
            }
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					-- bottom_search = true, -- use a classic bottom cmdline for search
					-- command_palette = true, -- position the cmdline and popupmenu together
					-- long_message_to_split = true, -- long messages will be sent to a split
					-- inc_rename = true, -- enables an input dialog for inc-rename.nvim
					-- lsp_doc_border = true, -- add a border to hover docs and signature help
				},
                messages = {
                    enabled = false,
                },
				views = {
					cmdline_popup = {
						cmdline_popup = {
							border = {
								style = "single",
								padding = { 2, 3 },
							},
							filter_options = {},
							win_options = {
								winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
							},
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "single",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							kind = "",
							find = "written",
						},
						opts = { skip = true },
					},
				},
			})
		end,
	},
}
