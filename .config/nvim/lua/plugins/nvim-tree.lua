-- Open on the left side
return {
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				hijack_netrw = true,
				open_on_tab = false,
				hijack_cursor = false,
				update_cwd = true,
				update_focused_file = {
					enable = true,
					update_cwd = true,
					ignore_list = {},
				},
				system_open = {
					cmd = nil,
					args = {},
				},
				filters = {
					dotfiles = false,
					custom = {},
				},
				git = {
					enable = true,
					ignore = true,
					timeout = 500,
				},
				view = {
					width = 30,
					hide_root_folder = false,
					side = "left",
					number = false,
					relativenumber = false,
				},
				trash = {
					cmd = "trash",
					require_confirm = true,
				},
				actions = {
					open_file = {
						quit_on_open = false,
						window_picker = {
							enable = false,
						},
					},
				},
			})
			require("keys").map(
				{ "n", "v" },
				"<leader>e",
				"<cmd>NvimTreeToggle<cr>",
				" File explorer"
			)
		end,
	},
}

