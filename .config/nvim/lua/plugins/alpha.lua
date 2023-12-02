return {
    {
        "goolord/alpha-nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VimEnter",
        config = function()
            -- hide bufferline in alpha
            vim.cmd("autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2")

            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local header = {
                [[                                                  ]],
                [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
                [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
                [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
                [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
                [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
                [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                [[                                                  ]],
                [[                                                  ]],
            }
            dashboard.section.header.val = header

            -- buttons
            dashboard.section.buttons.val = {
                dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
                dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("p", "󰱓  Projects", ":Telescope projects <CR>"),
                dashboard.button("s", "  Sessions", ":Telescope possession list<cr>"),
                dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
                dashboard.button("q", "󰗼  Quit", ":qa!<CR>"),
                -- Sessions (display only last used <display_num>)
                (function()
                    local display_num = 6   -- max 9?
                    local all_lines = 8     -- edit this to zoom/have more lines
                    local group = { type = "group", opts = { spacing = 0 } }
                    group.val = {
                        {
                            type = "text",
                            val = "Sessions",
                            opts = {
                                position = "center",
                            },
                        },
                    }
                    local path = vim.fn.stdpath("data") .. "/possession"
                    local files = vim.fn.systemlist("ls -t " .. path .. "/*.json")
                    spaces = 0
                    for i, file in pairs(files) do
                        local basename = vim.fs.basename(file):gsub("%.json", "")
                        local button = dashboard.button(
                            tostring(i),
                            "󰑐  " .. basename,
                            "<cmd>PossessionLoad " .. basename .. "<cr>"
                        )
                        table.insert(group.val, button)

                        spaces = spaces + 1

                        if i == display_num then
                            break
                        end
                    end
                    spaces = all_lines - spaces
                    return group
                end)(),
            }

            -- dynamically "scale" ui to the number of listed sessions
            for i = 1, spaces / 2 do
                table.insert(header, [[                                                  ]])
                table.insert(header, 1, [[                                                  ]])
            end

            -- random color for header
            local colors = { "#76cce0", "#9ed072", "#e7c664", "#b39df3", "#f39660" }
            local function random_color()
                math.randomseed(os.time())
                return colors[math.random(#colors)]
            end
            local vimcmd = 'highlight HeaderColor guifg=' .. random_color()
            vim.cmd(vimcmd)
            dashboard.section.header.opts.hl = "HeaderColor"
            dashboard.section.buttons.opts.cursor = 0

            dashboard.opts.opts.noautocmd = true
            -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
            alpha.setup(dashboard.opts)

            -- when closing the last buffer -> go to the alpha
            local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                pattern = "BDeletePost*",
                group = alpha_on_empty,
                callback = function(event)
                    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
                    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
                    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

                    if fallback_on_empty then
                        vim.cmd("Alpha")
                        vim.cmd(event.buf .. "bwipeout")
                    end
                end,
            })
        end,
    },
}
