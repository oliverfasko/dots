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

require("plugins")
require("keybinds")

vim.cmd.colorscheme('vague')
