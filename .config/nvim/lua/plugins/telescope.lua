-- Telescope fuzzy finding (all the things)
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
			"debugloop/telescope-undo.nvim",
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = true,
							["<C-d>"] = true,
						},
					},
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					layout_config = {
						anchor = "center",
						height = 0.8,
						width = 0.9,
						preview_width = 0.6,
						prompt_position = "bottom",
					},
				},
				extensions = {
					undo = {
						use_delta = true,
						side_by_side = false,
						entry_format = "󰣜 #$ID, $STAT, $TIME",
						layout_strategy = "flex",
						mappings = {
							i = {
								["<cr>"] = require("telescope-undo.actions").yank_additions,
								["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
								["<C-\\>"] = require("telescope-undo.actions").restore,
							},
						},
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
			-- Telescope-undo
			require("telescope").load_extension("undo")

			local map = require("keys").map
			map("n", "<leader>sr", require("telescope.builtin").oldfiles, " Recently opened")
			map("n", "<leader>so", require("telescope.builtin").buffers, "󱃢 Open buffers")
			map("n", "<leader>ss", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, " Search in buffer")

			map("n", "<leader>sf", require("telescope.builtin").find_files, " Files")
			map("n", "<leader>sh", require("telescope.builtin").help_tags, "󰋖 Help")
			map("n", "<leader>sw", require("telescope.builtin").grep_string, " Current word")
			map("n", "<leader>sg", require("telescope.builtin").live_grep, "󰮗 Grep")
			map("n", "<leader>sd", require("telescope.builtin").diagnostics, " Diagnostics")

			map("n", "<leader>sk", require("telescope.builtin").keymaps, "󰌌 Keymaps")

			map("n", "<leader>su", ':lua require("telescope").extensions.undo.undo()<cr>', " Undo history")
		end,
	},
	-- Commands
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
			map("n", "<leader>sc", "<cmd>Cheatsheet<cr>", "󰞋 Commands")
		end,
	},
}
