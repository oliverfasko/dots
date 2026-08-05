vim.g.mapleader = " "      
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true    
vim.opt.hlsearch = true         
vim.opt.incsearch = true         
vim.opt.ignorecase = true
vim.opt.smartcase = true         
vim.opt.wrap = true               
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.clipboard:append("unnamedplus")

-- default indentation (overridden per-filetype in after/ftplugin/)
vim.opt.expandtab = true   -- spaces, not tabs
vim.opt.shiftwidth = 4     -- >> / << and autoindent
vim.opt.tabstop = 4        -- width of a tab char
vim.opt.softtabstop = 4    -- width when pressing Tab/Backspace

require("plugins")
require("keybinds")

vim.cmd.colorscheme('vague')
