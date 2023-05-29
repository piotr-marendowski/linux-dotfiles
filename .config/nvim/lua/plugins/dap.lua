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
        config = function()
            local dap = require("dap")

            -- set keybindings
			require("keys").map({ "n", "v" }, "<leader>bb", function() dap.toggle_breakpoint() end, " Breakpoint")
			require("keys").map({ "n", "v" }, "<leader>bc", function() dap.continue() end, " Continue")
			require("keys").map({ "n", "v" }, "<leader>bo", function() dap.step_over() end, " Step over")
			require("keys").map({ "n", "v" }, "<leader>bi", function() dap.step_into() end, " Step into")

            -- configure C/C++ for debugging, NEEDS LLDB PACKAGE (on arch)
            dap.adapters.cpp = {
                type = 'executable',
                command = 'lldb-vscode',
                env = {
                  LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
                },
                name = "lldb"
              } dap.configurations.cpp = {
                {
                  name = "Launch",
                  type = "cpp",
                  request = "launch",
                  program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  cwd = '${workspaceFolder}',
                  args = {}
                }
              }

              dap.configurations.c = dap.configurations.cpp
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

			require("keys").map(
				{ "n", "v" }, "<leader>bd", function() dapui.toggle() end, " Debugging window"
			)
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
}
