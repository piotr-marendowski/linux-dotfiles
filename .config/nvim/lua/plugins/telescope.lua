-- Telescope fuzzy finding (all the things)
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available
            -- {
            -- 	"nvim-telescope/telescope-fzf-native.nvim",
            -- 	build = "make",
            -- 	cond = vim.fn.executable("make") == 1,
            -- },
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-ui-select.nvim", -- Override vim.ui.select()
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    layout_config = {
                        anchor = "center",
                        prompt_position = "bottom",
                        center = {
                            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                            height = 1,
                            width = 1,
                            prompt_position = "top",
                            preview_width = 0.9,
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
                        line_width = "full",
                    },
                },
                extensions = {
                    -- configure extensions here
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
}
