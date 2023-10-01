return {
    -- Comments
    -- gb => Toggle comment in visual mode
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
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
    -- Show colors (toggle)/color picker
    {
        "uga-rosa/ccc.nvim",
        event = "VeryLazy",
        config = function()
            local map = require("keys").map
            map("n", "<leader>oc", "<cmd>CccPick<cr>", " Color picker")
            map("n", "<leader>ot", "<cmd>CccHighlighterToggle<cr>", " Toggle colors")
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
        event = "VeryLazy",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    -- better buffer closing
    {
        "famiu/bufdelete.nvim",
        event = "BufEnter",
    },
    -- Ident lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            -- disable v.2 context highlighting
            scope = { enabled = false },
        },
    },
    -- Projects and autochdir in toggleterm
    {
        "ahmedkhalf/project.nvim",
        event = "VeryLazy",
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
    -- Smooth scrolling
    {
        "declancm/cinnamon.nvim",
        event = "VeryLazy",
        config = function()
            require("cinnamon").setup({
                extra_keymaps = true,
                override_keymaps = true,
                max_length = 500,
                scroll_limit = -1,
            })

            -- Disable Ctrl + F scrolling
            -- First unmap it
            local map = require("keys").map
            map("n", "<C-f>", "<Nop>", "")

            -- Then assign it (and works, I'm so smart I know)
            -- Exit without saving
            map("n", "<C-f>", "<cmd>q!<cr>", "")
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
        opts = {
            window = {
                width = .70; -- 70% of the screen
            },
            options = {
                signcolumn = "no",
            },
            plugins = {
                gitsigns = { enabled = false },
            },
        },
        config = function()
            local map = require("keys").map
            map("n", "<leader>z", "<cmd>ZenMode<cr>", "󰰶 ZenMode")
        end,
    },
    -- Automatically open files at the place of the last edit
    {
        "ethanholz/nvim-lastplace",
        config = function()
            require("nvim-lastplace").setup()
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
        event = "VeryLazy",
        opts = {
            cut_key = "t",
        },
    },
    -- Latex previewer
    -- NEEDS `meta-group-texlive-most` (AUR) PACKAGE!
    -- and `rubber` for error messages
    -- {
    --     "frabjous/knap",
    --     event = "VeryLazy",
    --     config = function()
    --         local map = require("keys").map
    --         map("n", "<leader>ox", function()
    --             require("knap").toggle_autopreviewing()
    --         end, " Latex")
    --     end,
    -- },
    -- Marks
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({
                mappings = {
                    -- set as map in order to display names in which-key
                    -- but when in normal mode, m => set mark on this line
                    prev = false, -- pass false to disable only this default mapping
                },
            })

            local map = require("keys").map
            map("n", "<leader>ml", "<cmd>MarksListAll<cr>", " List all marks")
            map("n", "<leader>md", function()
                require("marks").delete_line()
            end, "󰛌 Delete on line   ")
            map("n", "<leader>mi", function()
                require("marks").delete()
            end, "󰛌 Delete")
            map("n", "<leader>me", function()
                require("marks").delete_buf()
            end, "󰛌 Delete all")
            map("n", "<leader>mm", function()
                require("marks").set_next()
            end, "󰙒 Set next")
            map("n", "<leader>ms", function()
                require("marks").set()
            end, "󰙒 Set mark")
            map("n", "<leader>mn", function()
                require("marks").next()
            end, "󰒭 Go to next")
            map("n", "<leader>mp", function()
                require("marks").previous()
            end, "󰒮 Go to previous")
        end,
    },
    -- Folds
    -- za => toggle fold
    -- on folded line h => preview
    -- on folded line l => open
    {
        {
            "anuvyklack/pretty-fold.nvim",
            config = function()
                require("pretty-fold").setup({
                    fill_char = " ",
                })
            end,
        },
        {
            "anuvyklack/fold-preview.nvim",
            dependencies = {
                "anuvyklack/keymap-amend.nvim",
            },
            config = function()
                require("fold-preview").setup()
            end,
        },
    },
    -- Goto preview
    -- gp.. => goto preview
    {
        "rmagatti/goto-preview",
        event = "VeryLazy",
        config = function()
            require("goto-preview").setup({
                default_mappings = true,
            })
        end,
    },
    -- Ranger-like item navigation
    {
        "SmiteshP/nvim-navbuddy",
        event = "VeryLazy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim", -- Optional
            "nvim-telescope/telescope.nvim", -- Optional
        },
        config = function()
            local navbuddy = require("nvim-navbuddy")

            require("lspconfig").clangd.setup({
                on_attach = function(client, bufnr)
                    navbuddy.attach(client, bufnr)
                end,
            })

            local map = require("keys").map
            map("n", "<leader>cn", ':lua require("nvim-navbuddy").open()<cr>', "󰪏 Navbuddy")
        end,
    },
    -- Send buffers into early retirement by automatically closing
    -- them after x minutes of inactivity
    {
        "chrisgrieser/nvim-early-retirement",
        config = function()
            require("early-retirement").setup({
                retirementAgeMins = 10,
            })
        end,
    },
    -- Peek lines
    {
        "nacro90/numb.nvim",
        event = "VeryLazy",
        config = function()
            require("numb").setup()
        end,
    },
    -- Fast jumping to any text on the screen
    {
        "phaazon/hop.nvim",
        event = "VeryLazy",
        branch = "v2", -- optional but strongly recommended
        config = function()
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

            vim.keymap.set("", "f", "<cmd>HopWord<cr>", { remap = true })
        end,
    },
    -- nnn file manager
    {
        "luukvbaal/nnn.nvim",
        event = "VeryLazy",
        config = function()
            require("nnn").setup({
                picker = {
                    cmd = "nnn -edH",
                    style = {
                        -- percentage relative to terminal size when < 1, absolute otherwise
                        width = 90,
                        height = 0.6,
                        xoffset = 0.5,
                        yoffset = 0.5,
                        -- border decoration for example "rounded"(:h nvim_open_win)
                        border = "single"
                    },
                }
            })

            -- run in floating window with cwd
            local map = require("keys").map
            map("n", "<leader>e", '<cmd>NnnPicker %:p:h<cr>', " File manager")
        end
    },
    -- Smart column
    {
        "m4xshen/smartcolumn.nvim",
        event = "BufEnter",
        opts = {
            colorcolumn = "100",
            disabled_filetypes = { "lazy", "mason", "help", "alpha", "help", "text", "markdown" }
        }
    },
    -- Pomodoro timer
    {
        "dbinagi/nomodoro",
        config = function()
            require('nomodoro').setup({
                work_time = 25,
                break_time = 5,
                texts = {
                    status_icon = " ",
                },
            })
            local map = require("keys").map
            map("n", "<leader>ii", '<cmd>NomoWork<cr>', "󱫠 Start Timer")
            map("n", "<leader>ib", '<cmd>NomoStop<cr>', "󱫨 Stop Timer")
        end
    },
}
