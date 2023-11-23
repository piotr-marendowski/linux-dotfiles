-- Telescope fuzzy finding (all the things)
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-ui-select.nvim", -- Override vim.ui.select()
        },
        config = function()
            local fb_actions = require("telescope._extensions.file_browser.actions")
            local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    layout_config = {
                        height = 0.95,
                        anchor = "center",
                        prompt_position = "bottom",
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
                -- configure builtin pickers
                pickers = {
                    lsp_document_symbols = {
                        -- use this instead
                        symbols = { "function", "method", "class" },
                        -- ignore_symbols = { "string", "field", "package", "constructor",
                        -- "object", "array", "variable", "number" },
                    },
                    diagnostics = {
                        layout_strategy = "vertical",
                        layout_config = { preview_cutoff = 0 },
                        no_sign = true,
                        buffnr = 0, -- show only for current buffer
                    },
                },
                extensions = {
                    file_browser = {
                        display_stat = false,
                        hidden = true,
                        initial_mode = "normal",
                        -- Change behaviour to more ranger-like
                        mappings = {
                            n = {
                                h = fb_actions.goto_parent_dir,
                                k = actions.move_selection_worse,
                                j = actions.move_selection_better,
                                l = actions.select_default, -- action for going into directories and opening files
                            },
                        },
                    },
                },
            })

            -- Enable telescope fzf native, if installed
            -- pcall(require("telescope").load_extension, "fzf")
            require("telescope").load_extension("undo")
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("possession")

            local map = require("keys").map
            map("n", "<leader>sp", ":Telescope projects <CR>", "󰱓 Projects")
            map("n", "<leader>sr", require("telescope.builtin").oldfiles, " Recent files")
            -- map("n", "<leader>si", function()
            -- 	-- You can pass additional configuration to telescope to change theme, layout, etc.
            -- 	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes")
            -- 		--continue
            -- 		.get_ivy({
            -- 			previewer = false,
            -- 		}))
            -- end, " Search in buffer")
            map("n", "<leader>sf", require("telescope.builtin").find_files, " Files")
            map("n", "<leader>sh", require("telescope.builtin").help_tags, "󰋖 Help")
            map("n", "<leader>ss", require("telescope.builtin").lsp_document_symbols, " Symbols")
            map("n", "<leader>sg", require("telescope.builtin").live_grep, "󰮗 Grep")
            map("n", "<leader>sd", require("telescope.builtin").diagnostics, " Diagnostics")
            map("n", "<leader>sb", require("telescope.builtin").buffers, " Buffers")
            map("n", "<leader>su", ':lua require("telescope").extensions.undo.undo()<cr>', " Undo history")
        end,
    },
    -- Telescope file browser
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local map = require("keys").map
            map("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", " Files")
        end,
    },
}
