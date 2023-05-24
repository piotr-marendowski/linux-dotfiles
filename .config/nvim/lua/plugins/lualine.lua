-- Lualine with Tokyo Night theme
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				disabled_filetypes = { "NvimTree", "alpha" },
				theme = 'tokyonight',
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
			},
			sections = {
				lualine_c = {},
				lualine_x = {'filetype'},
			}
		})
	end,
}
