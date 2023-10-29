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
}
