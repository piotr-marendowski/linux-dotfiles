return {
	"nvim-lualine/lualine.nvim",
	config = function()
        -- Display session name
		local function session_name()
			return ("󰑐 " .. require("possession.session").session_name) or ""
		end
		require("lualine").setup({
			options = {
				disabled_filetypes = { "alpha" },
				-- theme = "tokyonight",
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				always_divide_middle = true,
			},
			sections = {
				lualine_c = {},
				lualine_x = {},
				lualine_y = { session_name, "progress" },
			},
		})
	end,
}
