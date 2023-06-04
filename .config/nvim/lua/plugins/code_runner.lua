return {
	{
		"CRAG666/code_runner.nvim",
		event = "VeryLazy",
		config = function()
			require("code_runner").setup({
				filetype = {
					java = {
						"cd $dir &&",
						"javac $fileName &&",
						"java $fileNameWithoutExt",
					},
					python = "python3 -u",
					typescript = "deno run",
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
			map("n", "<leader>cr", "<cmd>RunCode<cr>", " Run code")
			map("n", "<leader>ce", "<cmd>RunCode c89<cr>", " Run code (C89)")

			-- Run code and specify which one preset to use
			function RunCodePrompt()
				local input = vim.fn.input("Enter code to run: ")
				if input ~= "" then
					vim.cmd(":RunCode " .. input)
				end
			end

			map("n", "<leader>ci", "<cmd>:lua RunCodePrompt()<cr>", " Run code (input)")
		end,
	},
}
