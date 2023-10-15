return {
	{
		"CRAG666/code_runner.nvim",
		event = "VeryLazy",
		config = function()
			require("code_runner").setup({
                mode = "float",
                float = { border = "single" },
				filetype = {
                    c = {
                        "cd $dir &&",
                        "gcc $fileName",
                        "-o $fileNameWithoutExt &&",
                        "$dir/$fileNameWithoutExt",
                    },
                    cpp = {
                        "cd $dir &&",
                        "g++ $fileName",
                        "-o $fileNameWithoutExt &&",
                        "$dir/$fileNameWithoutExt",
                    },
					java = {
						"cd $dir &&",
						"javac $fileName &&",
						"java $fileNameWithoutExt",
					},
					python = "python3 -u",
					rust = {
						"cd $dir &&",
						"rustc $fileName &&",
						"$dir/$fileNameWithoutExt",
					},
					c89 = {
						"cd $dir &&",
						"gcc $fileName -o $fileNameWithoutExt -std=c89 &&",
						"$dir/$fileNameWithoutExt",
					},
					c99 = {
						"cd $dir &&",
						"gcc $fileName -o $fileNameWithoutExt -std=c99 &&",
						"$dir/$fileNameWithoutExt",
					},
				},
			})

			local map = require("keys").map
			map("n", "<leader>r", "<cmd>RunCode<cr>", " Run code")

			-- Run code and specify which one preset to use
			function RunCodePrompt()
				local input = vim.fn.input("Enter name: ")
				if input ~= "" then
					vim.cmd(":RunCode " .. input)
				end
			end

			map("n", "<leader>ci", "<cmd>:lua RunCodePrompt()<cr>", " Run (input)")
		end,
	},
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },
}
