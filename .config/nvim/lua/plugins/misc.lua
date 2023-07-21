return {
	-- Comments
	{
		"numToStr/Comment.nvim",
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
	-- Show colors
	{
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			require("colorizer").setup()
		end,
	},
	-- Better glance at matched information
	-- Ctrl + / => stop searching
	{
		"kevinhwang91/nvim-hlslens",
		event = "VeryLazy",
		config = function()
			require("hlslens").setup()
			local map = require("keys").map
			map("n", "<C-_>", "<cmd>nohlsearch<cr>", " Stop matching")
		end,
	},
	-- Autopairs
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

			-- Alt + J/K => normal scroll,
			-- Half-window movements:
			vim.keymap.set({ "n", "x" }, "<A-k>", "<Cmd>lua Scroll('<C-u>', 1, 1)<CR>")
			vim.keymap.set({ "n", "x" }, "<A-j>", "<Cmd>lua Scroll('<C-d>', 1, 1)<CR>")

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
	-- Autosave
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup({
				-- don't show the message every auto-save
				execution_message = {
					message = "",
				},
			})
		end,
	},
	-- Zen mode
	{
		"folke/zen-mode.nvim",
		event = "VeryLazy",
		dependencies = {
			"folke/twilight.nvim",
			config = function()
				local map = require("keys").map
				map("n", "<leader>ot", "<cmd>Twilight<cr>", " Twilight ")
			end,
		},
		opts = {},
		config = function()
			local map = require("keys").map
			map("n", "<leader>oz", "<cmd>ZenMode<cr>", "󰰶 ZenMode ")
		end,
	},
	-- Automatically open files at the place of the last edit
	{
		"ethanholz/nvim-lastplace",
		config = function()
			require("nvim-lastplace").setup()
		end,
	},
	-- Rename symbol
	{
		"filipdutescu/renamer.nvim",
		event = "VeryLazy",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("renamer").setup({
				-- The minimum width of the popup
				min_width = 30,
				-- The maximum width of the popup
				max_width = 50,
				border_chars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			})

			local map = require("keys").map
			map("n", "<leader>cc", function()
				require("renamer").rename()
			end, "󰑕 Rename symbol")
		end,
	},
	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		event = "VeryLazy",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		opts = {
			mkdp_auto_start = 1,
		},
		config = function()
			local map = require("keys").map
			map("n", "<leader>op", "<cmd>MarkdownPreview<cr>", " Markdown")
		end,
	},
	-- Overrides the delete operations to actually just delete and not affect the current yank
	{
		"gbprod/cutlass.nvim",
		-- TODO: add keybind to copy and cut
		opts = {},
	},
	-- Latex previewer
    -- NEEDS meta-group-texlive-most (AUR) PACKAGE!
    -- If you get error: rubber-info: command not found then don't install rubber just look for errors in code, because rubber is not necessary
	{
		"frabjous/knap",
		config = function()

			local map = require("keys").map
			map("n", "<leader>ox", function() require("knap").toggle_autopreviewing() end, " Latex")
		end,
	},
}
