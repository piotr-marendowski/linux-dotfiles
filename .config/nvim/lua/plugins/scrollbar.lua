-- scrollbar
return {
	{
		"petertriho/nvim-scrollbar",
		config = function()
			-- use tokyonight colors
			local colors = require("tokyonight.colors").setup()
			require("scrollbar.handlers.gitsigns").setup() -- enable gitsigns

			require("scrollbar").setup({
				handle = {
					color = colors.terminal_black,
					blend = 0,
				},
				marks = {
					-- don't display dot
					Cursor = {
						text = " ",
					    color = colors.terminal_black,
					},

					Error = { color = colors.error },
					Warn = { color = colors.warning },
					Info = { color = colors.info },
					Hint = { color = colors.hint },
					Misc = { color = colors.purple },

					GitAdd = {
						text = { "-", "=" },
						color = colors.green,
					},
					GitChange = {
						text = { "-", "=" },
						color = colors.orange,
					},
					GitDelete = {
						text = { "-", "=" },
						color = colors.error,
					},
				},
				excluded_filetypes = {
					"NvimTree",
					"alpha",
					"lazygit",
				},
			})
		end,
	},
}
