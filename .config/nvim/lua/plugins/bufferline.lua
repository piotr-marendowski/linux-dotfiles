return {
	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require('bufferline')
			bufferline.setup({
				options = {
					indicator = {
						style = "none",
					},
					max_name_length = 25,
					max_prefix_length = 25, -- prefix used when a buffer is de-duplicated
					tab_size = 21,
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
							-- separator = true,
							padding = 1,
						},
						{
							filetype = "Alpha",
							text = "File Explorer",
							text_align = "center",
							-- separator = true,
							padding = 1,
						},
					},
					show_buffer_close_icons = false,
					show_close_icon = false,
					show_tab_indicators = true,
                    diagnostics = "nvim_lsp",
				}
			})
            -- Navigate buffers
			local map = require("keys").map
            map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
            map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
            map("n", "<A-l>", "<cmd>BufferLineMoveNext<CR>", "Move next buffer")
            map("n", "<A-h>", "<cmd>BufferLineMovePrev<CR>", "Move previous buffer")
		end,
	},
}
