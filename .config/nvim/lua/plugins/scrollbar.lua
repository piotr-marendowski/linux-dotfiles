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
                    --colors
                    -- get default colors for them
					Error = { text = { "|", "=" }},
					Warn = { text = { "|", "=" }},
					Info = { text = { "|", "=" }},
					Hint = { text = { "|", "=" }},
					Misc = { text = { "|", "=" }},
					GitAdd = { text = "|" },
					GitChange = { text = "|" },
					GitDelete = { text = "|" },
				},
				excluded_filetypes = {
					"NvimTree",
					"alpha",
					"lazygit",
				},
                handlers = {
					-- don't display cursor with dot
                    cursor = false,
                    gitsigns = true,    -- Requires gitsigns
                    search = false,     -- Requires hlslens
                }
			})
		end,
	},
}
