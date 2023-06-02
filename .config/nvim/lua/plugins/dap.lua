return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },
    {
        "mfussenegger/nvim-dap",
		event = "VeryLazy",
        dependencies = { "Microsoft/vscode-cpptools" },
        config = function()
            local dap = require("dap")

            -- set keybindings
			require("keys").map({ "n", "v" }, "<leader>bb", function() dap.toggle_breakpoint() end, " Breakpoint")
			require("keys").map({ "n", "v" }, "<leader>bc", function() dap.continue() end, " Continue")
			require("keys").map({ "n", "v" }, "<leader>bo", function() dap.step_over() end, " Step over")
			require("keys").map({ "n", "v" }, "<leader>bi", function() dap.step_into() end, " Step into")

            -- configure C/C++ for debugging
            dap.adapters.cppdbg = {
              id = 'cppdbg',
              type = 'executable',
              command = '/home/mike/.local/share/nvim/mason/bin/OpenDebugAD7'
            }
            dap.configurations.cpp = {
              {
                name = "Debug C/C++/Rust code",
                type = "cppdbg",
                request = "launch",
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = true,
              },
              {
                name = 'Attach to gdbserver :1234',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                miDebuggerServerAddress = 'localhost:1234',
                miDebuggerPath = '/usr/bin/gdb',
                cwd = '${workspaceFolder}',
                program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
              },
            }

            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
		event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local dapui = require("dapui")
            dapui.setup()

			require("keys").map({ "n", "v" }, "<leader>bd", function() dapui.toggle() end, " Debugging window")

            -- use nvim-dap events to open and close the windows automatically
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
        config = function()
            require('nvim-dap-virtual-text').setup()
        end,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
		event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require('telescope').load_extension('dap')
        end,
    },
    'ldelossa/nvim-dap-projects',
}
