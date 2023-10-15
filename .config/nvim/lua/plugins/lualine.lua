-- Lualine with Tokyo Night theme
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local function session_name()
			return "󰑐 " .. (require("possession.session").session_name or "")
		end

		require("lualine").setup({
			options = {
				disabled_filetypes = { "alpha" },
				theme = "tokyonight",
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
			},
			sections = {
				lualine_c = {},
				lualine_x = { session_name },
			},
		})
	end,
}
