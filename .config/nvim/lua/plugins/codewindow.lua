return {
	{
		"gorbit99/codewindow.nvim", config = function()
			local codewindow = require("codewindow")
			-- use tokyonight colors
			-- local colors = require("tokyonight.colors").setup()

        codewindow.setup({
				auto_enable = false, -- autostart on every buffer opening
				exclude_filetypes = { "alpha" },
				minimap_width = 10,
				window_border = "", -- no border
                screen_bounds = "background", -- vs-code like shadow
                show_cursor = false,
			})
			codewindow.apply_default_keybinds()

			-- Minimap colors
			-- vim.api.nvim_set_hl(0, "CodewindowBackground", { fg = colors.dark3 })
			-- vim.api.nvim_set_hl(0, "CodewindowUnderline", { fg = colors.fg })
			-- vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = colors.dark3 })
			-- vim.api.nvim_set_hl(0, "CodewindowBoundsBackground", { fg = colors.fg_dark })
			-- vim.api.nvim_set_hl(0, "CodewindowWarn", { fg = colors.dark3 })
			-- vim.api.nvim_set_hl(0, "CodewindowError", { fg = colors.dark3 })
			-- vim.api.nvim_set_hl(0, "CodewindowAddition", { fg = colors.dark3 })
			-- vim.api.nvim_set_hl(0, "CodewindowDeletion", { fg = colors.dark3 })

            -- Unmap default mappings
			local map = require("keys").map
			map("n", "<leader>mc", "<Nop>", "")
			map("n", "<leader>mf", "<Nop>", "")
			map("n", "<leader>mm", "<Nop>", "")
			map("n", "<leader>mo", "<Nop>", "")

			-- Toggle minimap
			require("keys").map({ "n", "v" }, "<leader>ok", function()
				codewindow.toggle_minimap()
			end, " Minimap")

			-- Toggle minimap and auto focus on it
			-- require("keys").map({ "n", "v" }, "<leader>of", function()
			-- 	codewindow.toggle_focus()
			-- end, " Minimap (focus)  ")
		end,
	},
}
