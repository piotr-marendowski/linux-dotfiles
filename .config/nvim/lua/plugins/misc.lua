return {
    -- Comments
    -- gb => Toggle block comment in visual mode
    -- gcc => Toggle line comment in visual mode
    {
        "numToStr/Comment.nvim",
        lazy = false,
        opts = {},
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
        "NvChad/nvim-colorizer.lua",
        config = function()
            require "colorizer".setup({
                user_default_options = {
                    names = false, -- "Name" codes like Blue or blue
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    rgb_fn = true, -- CSS rgb() and rgba() functions
                    hsl_fn = true, -- CSS hsl() and hsla() functions
                    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    mode = "foreground",
                },
            })
        end,
    },
    -- Better glance at matched information
    -- Ctrl + / => stop searching
    {
        "kevinhwang91/nvim-hlslens",
        event = "BufEnter",
        config = function()
            require("hlslens").setup()

            local map = require("keys").map
            map("n", "<C-_>", "<cmd>nohlsearch<cr>", " Stop matching")
        end,
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "BufEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    -- Better buffer closing
    {
        "famiu/bufdelete.nvim",
        event = "BufEnter",
    },
    -- Ident lines
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufEnter",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "." },
                -- disable context highlighting (v.2)
                scope = { enabled = false },
            })
            -- disable first level
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        end,
    },
    -- Projects and autochdir in toggleterm
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
                default_delay = 5,
            })

            -- Exit without saving -> disable Ctrl + F scrolling
            -- First unmap it
            local map = require("keys").map
            map("n", "<C-f>", "<Nop>", "")
            -- Then assign it (and works, I'm so smart I know)
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
        opts = {
            mkdp_auto_start = 1,
        },
        config = function()
            vim.fn["mkdp#util#install"]()

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
    -- Send buffers into early retirement by automatically closing
    -- them after x minutes of inactivity
    {
        "chrisgrieser/nvim-early-retirement",
        config = function()
            require("early-retirement").setup({
                retirementAgeMins = 15,
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
    -- Make help windows floating
    {
        "Tyler-Barham/floating-help.nvim",
        event = "VeryLazy",
        config = function()
            require("floating-help").setup({
                width = 0.7, -- Whole numbers are columns/rows
                height = 0.7, -- Decimals are a percentage of the editor
                position = "C", -- NW,N,NW,W,C,E,SW,S,SE (C==center)
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            })

            -- Only replace cmds, not search; only replace the first instance
            local function cmd_abbrev(abbrev, expansion)
                local cmd = "cabbr "
                    .. abbrev
                    .. ' <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "'
                    .. expansion
                    .. '" : "'
                    .. abbrev
                    .. '")<CR>'
                vim.cmd(cmd)
            end

            -- Redirect `:h` to `:FloatingHelp`
            cmd_abbrev("h", "FloatingHelp")
            cmd_abbrev("help", "FloatingHelp")
            cmd_abbrev("helpc", "FloatingHelpClose")
            cmd_abbrev("helpclose", "FloatingHelpClose")
        end,
    },
    -- Better escape
    "nvim-zh/better-escape.vim",
}
