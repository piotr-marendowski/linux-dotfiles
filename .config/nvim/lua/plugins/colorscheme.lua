return {
    {
        "sainnhe/sonokai",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd("colorscheme sonokai")
        end,
        --[[
            [0] = "#2c2e34", /* background */ 
            [1] = "#fc5d7c", /* red     */
            [2] = "#9ed072", /* green   */
            [3] = "#e7c664", /* yellow  */
            [4] = "#76cce0", /* blue    */
            [5] = "#b39df3", /* purple */
            [6] = "#f39660", /* orange  */
            [7] = "#e2e2e3", /* white   */

            /* 8 bright colors */
            [8]  = "#7f8490", /* black   */
            [9] = "#fc5d7c", /* red     */
            [10] = "#9ed072", /* green   */
            [11] = "#e7c664", /* yellow  */
            [12] = "#76cce0", /* blue    */
            [13] = "#b39df3", /* purple */
            [14] = "#f39660", /* orange  */
            [15] = "#e2e2e3", /* white   */
        ]]
    },
    "folke/tokyonight.nvim",
	--[[ 
        [0] = "#24283b", /* background */ 
        [1] = "#f7768e", /* red     */
        [2] = "#9ece6a", /* green   */
        [3] = "#e0af68", /* yellow  */
        [4] = "#7aa2f7", /* blue    */
        [5] = "#bb9af7", /* purple */
        [6] = "#2ac3de", /* cyan    */
        [7] = "#c0caf5", /* white   */

        /* 8 bright colors */
        [8]  = "#24283b", /* black   */
        [9]  = "#f7768e", /* red     */
        [10] = "#9ece6a", /* green   */
        [11] = "#e0af68", /* yellow  */
        [12] = "#7aa2f7", /* blue    */
        [13] = "#bb9af7", /* purple */
        [14] = "#73daca", /* cyan    */
        [15] = "#c0caf5", /* white   */
    ]]
    {
        'kepano/flexoki-neovim',
        --[[ Base tones
        Value 	Hex 	RGB
        black 	#100F0F 	16, 15, 15
        950 	#1C1B1A 	28, 27, 26
        900 	#282726 	40, 39, 38
        850 	#343331 	52, 51, 49
        800 	#403E3C 	64, 62, 60
        700 	#575653 	87, 86, 83
        600 	#6F6E69 	111, 110, 105
        500 	#878580 	135, 133, 128
        300 	#B7B5AC 	183, 181, 172
        200 	#CECDC3 	206, 205, 195
        150 	#DAD8CE 	218, 216, 206
        100 	#E6E4D9 	230, 228, 217
        50 	    #F2F0E5 	242, 240, 229
        paper 	#FFFCF0 	255, 252, 240
        Dark colors
        Color 	Hex 	RGB
        red 	#AF3029 	175, 48, 41
        orange 	#BC5215 	188, 82, 21
        yellow 	#AD8301 	173, 131, 1
        green 	#66800B 	102, 128, 11
        cyan 	#24837B 	36, 131, 123
        blue 	#205EA6 	32, 94, 166
        purple 	#5E409D 	94, 64, 157
        magenta #A02F6F 	160, 47, 111
        Light colors
        Color 	Hex 	RGB
        red 	#D14D41 	209, 77, 65
        orange 	#DA702C 	218, 112, 44
        yellow 	#D0A215 	208, 162, 21
        green 	#879A39 	135, 154, 57
        cyan 	#3AA99F 	58, 169, 159
        blue 	#4385BE 	67, 133, 190
        purple 	#8B7EC8 	139, 126, 200
        magenta #CE5D97 	206, 93, 151 ]]
    }
}
