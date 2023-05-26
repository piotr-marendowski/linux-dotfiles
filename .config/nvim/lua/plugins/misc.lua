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
	-- Better buffer closing actions. Available via the buffers helper.
	{
		"kazhala/close-buffers.nvim",
		opts = {
			preserve_window_layout = { "this", "nameless" },
		},
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
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.move").setup()
		end,
	},
	-- scrollbar
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup({
			    excluded_filetypes = {
					"cmp_docs",
					"cmp_menu",
					"noice",
					"prompt",
					"TelescopePrompt",
					"NvimTree",
				},
			})
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
}
