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
    -- ident lines
    {
        "lukas-reineke/indent-blankline.nvim",

        config = function()
            require("indent_blankline").setup({
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = false,
            })
        end,
    },
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

            -- Disable Ctrl + F scrolling
            -- First unmap it
            local map = require("keys").map
            map("n", "<C-f>", "<Nop>", "")

            -- Then assign it (and works, I'm so smart I know)
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
                map("n", "<leader>tt", "<cmd>Twilight<cr>", " Twilight")
            end,
        },
        opts = {},
        config = function()
            local map = require("keys").map
            map("n", "<leader>tz", "<cmd>ZenMode<cr>", "󰰶 ZenMode")
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
        opts = {
            cut_key = "t",
        },
    },
    -- Latex previewer
    -- NEEDS meta-group-texlive-most (AUR) PACKAGE!
    -- If you get error: rubber-info: command not found then don't install rubber,
    -- just look for errors in code, because rubber is not necessary
    {
        "frabjous/knap",
        event = "VeryLazy",
        config = function()
            local map = require("keys").map
            map("n", "<leader>ox", function()
                require("knap").toggle_autopreviewing()
            end, " Latex")
        end,
    },
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
        config = function()
            require("goto-preview").setup({
                default_mappings = true,
            })
        end,
    },
    -- Ranger-like item navigation
    {
        "SmiteshP/nvim-navbuddy",
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
    -- Delete all buffers except opened
    {
        "numtostr/BufOnly.nvim",
        config = function()
            local map = require("keys").map
            map("n", "<leader>ob", "<cmd>BufOnly<cr>", " Delete buffers")
        end,
    },
    -- Send buffers into early retirement by automatically closing them after x minutes of inactivity
    {
        "chrisgrieser/nvim-early-retirement",
        event = "VeryLazy",
        config = function()
            require("early-retirement").setup({
                retirementAgeMins = 5,
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
    -- Sessions
    {
        "gennaro-tedesco/nvim-possession",
        dependencies = {
            "ibhagwan/fzf-lua",
        },
        config = function()
            require("nvim-possession").setup()

            local map = require("keys").map
            map("n", "<leader>pl", ':lua require("nvim-possession").list()<cr>', " List sessions")
            map("n", "<leader>pn", ':lua require("nvim-possession").new()<cr>', " New session")
            map("n", "<leader>pu", ':lua require("nvim-possession").update()<cr>', "󰚰 Update sessions")
            map("n", "<leader>pd", ':lua require("nvim-possession").delete()<cr>', "󰺝 Delete")
        end,
    },
    -- Fast jumping to any text on the screen
    {
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

            vim.keymap.set("", "f", "<cmd>HopWord<cr>", { remap = true })
        end,
    },
}
