return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "HiPhish/nvim-ts-rainbow2" },
	build = function()
	require("nvim-treesitter.install").update({ with_sync = true })
    local rainbow = require 'ts-rainbow'

    require("nvim-treesitter.configs").setup({
        enable = true, -- false will disable the whole extension
        disable = { 'help' }, -- list of language that will be disabled

        rainbow = {
            query = {
               'rainbow-parens'
            },
            strategy = rainbow.strategy.global,
            hlgroups = {
               'TSRainbowRed',
               'TSRainbowYellow',
               'TSRainbowBlue',
               'TSRainbowOrange',
               'TSRainbowGreen',
               'TSRainbowViolet',
               'TSRainbowCyan'
            },
        }
    })
	end
}
