return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
	 	config = function ()
			local map = require("keys").map
			map("n", "<leader>ta", "<cmd>TroubleToggle<cr>", "Toggle Trouble")
			map("n", "<leader>tb", "<cmd>TroubleRefresh<cr>", "Refresh Trouble")
		end
	},
}
