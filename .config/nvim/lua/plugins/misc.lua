return {
	-- Comments
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup()
		end,
	}, -- Code formatter just in case
	{
		"sbdchd/neoformat",
		event = "VeryLazy",
		config = function()
			local map = require("keys").map
			map("n", "<leader>cf", "<cmd>Neoformat<cr>", " Format")
		end,
	},
	-- Image previewer in ascii
	{
		"samodostal/image.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"m00qek/baleia.nvim",
		},
		config = function()
			require("image").setup({
				render = {
					min_padding = 5,
					show_label = true,
					use_dither = true,
					foreground_color = true,
					background_color = true,
				},
				events = {
					update_on_nvim_resize = true,
				},
			})
		end,
	},
	-- Cheatsheet
	{
		"sudormrfbin/cheatsheet.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("cheatsheet").setup()

			local map = require("keys").map
			map("n", "<leader>sc", "<cmd>Cheatsheet<cr>", "󰞋 Cheatsheet")
		end,
	},
	-- show colors
	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			require("colorizer").setup()
		end,
	},
	-- Better glance at matched information
    -- Ctrl + / => disable searching
	{
		"kevinhwang91/nvim-hlslens",
		event = "VeryLazy",
		config = function()
			-- ctrl + forward slash to stop searching
			local map = require("keys").map
			map("n", "<C-_>", "<cmd>nohlsearch<cr>", " Stop matching")
		end,
	},
	-- Auto autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	"lukas-reineke/indent-blankline.nvim", -- ident lines
	"famiu/bufdelete.nvim", -- better buffer closing
	-- projects and autochdir in toggleterm
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
			})

			require("telescope").load_extension("projects")
		end,
	},
	-- minimap
	{
		"gorbit99/codewindow.nvim",
		config = function()
			local codewindow = require("codewindow")
			-- use tokyonight colors
			local colors = require("tokyonight.colors").setup()

			codewindow.setup({
				auto_enable = true, -- autostart on every buffer opening
				window_border = "", -- no border
				exclude_filetypes = { "NvimTree", "alpha" },
				minimap_width = 10,
			})
			codewindow.apply_default_keybinds()

			-- make minimap greyier
			vim.api.nvim_set_hl(0, "CodewindowBackground", { fg = colors.dark3 })
			vim.api.nvim_set_hl(0, "CodewindowUnderline", { fg = colors.fg })

			-- Toggle minimap
			require("keys").map({ "n", "v" }, "<leader>oi", function()
				codewindow.toggle_minimap()
			end, " Minimap (toggle)")

			-- Toggle minimap and auto focus on it
			require("keys").map({ "n", "v" }, "<leader>oo", function()
				codewindow.toggle_focus()
			end, " Minimap (focus)")
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
					color = colors.terminal_black ,
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
	-- smooth scrolling
	{
		"declancm/cinnamon.nvim",
		config = function()
			require("cinnamon").setup({
				extra_keymaps = true,
				override_keymaps = true,
				max_length = 500,
				scroll_limit = -1,
			})

			-- J/K + Ctrl => normal scroll,
			-- Half-window movements:
			vim.keymap.set({ "n", "x" }, "<C-k>", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
			vim.keymap.set({ "n", "x" }, "<C-j>", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")

			-- First unmap these
			local map = require("keys").map
			map("n", "<C-f>", "<Nop>", "")
			map("n", "<C-d>", "<Nop>", "")

			-- Then assign them (and works, I'm so smart I know)
			-- Save and exit
			map("n", "<C-d>", "<cmd>NvimTreeClose | wq<cr>", "")
			-- Exit without saving
			map("n", "<C-f>", "<cmd>NvimTreeClose | q!<cr>", "")
		end,
	},
}
