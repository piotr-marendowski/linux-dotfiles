-- Open terminal from the bottom
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				shade_terminals = false,
				direction = "float",
				autochdir = true,
                persist_mode = true,
				shell = vim.o.shell,
				float_opts = {
					width = 120,
					height = 30,
				},
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
			end

			-- if you only want these mappings for toggle term use term://toggleterm instead
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			-- lazygit integration
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function()
					vim.cmd("startinsert!")
				end,
			})

			-- auto cwd for lazygit
			-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
			-- local cur_cwd = vim.fn.getcwd()

			function _LAZYGIT_TOGGLE()
				-- cwd is the root of project. if cwd is changed, change the git.
				local cwd = vim.fn.getcwd()
				if cwd ~= cur_cwd then
					cur_cwd = cwd
					lazygit:close()
					lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
				end
				lazygit:toggle()
			end

			-- auto cwd in terminal for projects
			-- vim.api.nvim_create_autocmd({ "DirChanged" }, {
			-- 	pattern = { "window", "global" },
			-- 	callback = function()
			-- 		if Terminal:is_open() then
			-- 			Terminal:send(string.format("cd %s", vim.fn.getcwd()), true)
			-- 		end
			-- 	end,
			-- })
			--
			-- auto cwd in terminal for everything
			vim.cmd("autocmd BufEnter * silent! lcd %:p:h")

			local map = require("keys").map
			map("n", "<leader>l", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", " Lazygit")
		end,
	},
	-- Open nvim files from terminal in editor
	{
		"willothy/flatten.nvim",
		lazy = false,
        event = VimEnter,
		opts = function()
			---@type Terminal?
			local saved_terminal

			return {
				window = {
					open = "alternate",
				},
				callbacks = {
					should_block = function(argv)
						-- Note that argv contains all the parts of the CLI command, including
						-- Neovim's path, commands, options and files.
						-- See: :help v:argv

						-- In this case, we would block if we find the `-b` flag
						-- This allows you to use `nvim -b file1` instead of
						-- `nvim --cmd 'let g:flatten_wait=1' file1`
						return vim.tbl_contains(argv, "-b")

						-- Alternatively, we can block if we find the diff-mode option
						-- return vim.tbl_contains(argv, "-d")
					end,
					pre_open = function()
						local term = require("toggleterm.terminal")
						local termid = term.get_focused_id()
						saved_terminal = term.get(termid)
					end,
					post_open = function(bufnr, winnr, ft, is_blocking)
						if is_blocking and saved_terminal then
							-- Hide the terminal while it's blocking
							saved_terminal:close()
						else
							-- If it's a normal file, just switch to its window
							vim.api.nvim_set_current_win(winnr)

							-- If we're in a different wezterm pane/tab, switch to the current one
							-- Requires willothy/wezterm.nvim
							require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
						end

						-- If the file is a git commit, create one-shot autocmd to delete its buffer on write
						-- If you just want the toggleable terminal integration, ignore this bit
						if ft == "gitcommit" or ft == "gitrebase" then
							vim.api.nvim_create_autocmd("BufWritePost", {
								buffer = bufnr,
								once = true,
								callback = vim.schedule_wrap(function()
									vim.api.nvim_buf_delete(bufnr, {})
								end),
							})
						end
					end,
					block_end = function()
						-- After blocking ends (for a git commit, etc), reopen the terminal
						vim.schedule(function()
							if saved_terminal then
								saved_terminal:open()
								saved_terminal = nil
							end
						end)
					end,
				},
			}
		end,
	},
}
