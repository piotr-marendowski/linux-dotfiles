-- minimap
return {
	{
		"gorbit99/codewindow.nvim", config = function()
			local codewindow = require("codewindow")
			-- use tokyonight colors
			local colors = require("tokyonight.colors").setup()

			codewindow.setup({
				auto_enable = false, -- autostart on every buffer opening
				window_border = "", -- no border
				exclude_filetypes = { "NvimTree", "alpha" },
				minimap_width = 10,
			})
			codewindow.apply_default_keybinds()

			-- Minimap colors
			vim.api.nvim_set_hl(0, "CodewindowBackground", { fg = colors.dark3 })
			vim.api.nvim_set_hl(0, "CodewindowUnderline", { fg = colors.fg })

            -- Unmap default mappings
			local map = require("keys").map
			map("n", "<leader>mc", "<Nop>", "")
			map("n", "<leader>mf", "<Nop>", "")
			map("n", "<leader>mm", "<Nop>", "")
			map("n", "<leader>mo", "<Nop>", "")

			-- Toggle minimap
			require("keys").map({ "n", "v" }, "<leader>om", function()
				codewindow.toggle_minimap()
			end, " Minimap " )

			-- Toggle minimap and auto focus on it
			require("keys").map({ "n", "v" }, "<leader>oo", function()
				codewindow.toggle_focus()
			end, " Minimap (focus)")
		end,
	},
}
