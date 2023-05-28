return {
	-- Comments
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end
	},
	-- Better glance at matched information
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			-- ctrl + forward slash to stop searching
			local map = require("keys").map
			map("n", "<C-_>", "<cmd>nohlsearch<cr>", " Stop matching")
		end
	},
	-- Auto autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-surround", -- Surround stuff with the ys-, cs-, ds- commands
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow"
	},
	"lukas-reineke/indent-blankline.nvim", -- ident lines
	"famiu/bufdelete.nvim", -- better buffer closing
	-- projects and autochdir in toggleterm
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup ({
				sync_root_with_cwd = true,
					respect_buf_cwd = true,
					update_focused_file = {
						enable = true,
						update_root = true
					},
			})
		end
	},
	{
		"echasnovski/mini.nvim",
		version = '*',
		config = function()
			local map = require('mini.map')

			require('mini.map').setup({
				components = {
					minimap = true,
				},
				minimap = {
					auto_start = true,
					width = 10,
					highlight_group = 'MiniMap',
				},
				symbols = {
					-- Scrollbar parts for view and line.
					-- Use empty string to disable any.
					scroll_line = '',
					scroll_view = '',
				},
				window = {
					winblend = 100,
					-- Don't need extra column
					show_integration_count = true,
				},
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.gitsigns(),
					map.gen_integration.diagnostic(),
				},
			})

			require("keys").map(
				{ "n", "v" },
				"<leader>oi",
				function() require('mini.map').toggle() end,
				" Minimap (toggle)"
			)

			require("keys").map(
				{ "n", "v" }, "<leader>oo",
				function()
					require('mini.map').open()
					vim.wait(100)
					require('mini.map').toggle_focus()
				end,
				" Minimap (focus)"
			)
		end,
	},
	-- scrollbar
	{
		"petertriho/nvim-scrollbar",
		config = function()
			-- use tokyonight colors
			local colors = require("tokyonight.colors").setup()
			require("scrollbar.handlers.gitsigns").setup() -- enable gitsigns

			require("scrollbar").setup({
				handle = {
					color = "#32344a",
					blend = 0,
				},
				marks = {
					-- don't display dot
					Cursor = {
						text = "",
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
				},
			})
		end,
	},
}
