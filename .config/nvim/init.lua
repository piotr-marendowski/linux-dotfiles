-- License: GPL v.3 NERD-FONT WITH ICONS IS REQUIRED TO VIEW ICONS!
-- Load options
require("options")

-- Handle plugins with lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
-- Use a protected call so we don't error out on first use
local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

-- Load plugins and make border boxy
require("lazy").setup("plugins", {
	ui = { border = "single" },
})

