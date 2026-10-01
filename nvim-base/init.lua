-- nvim-base: generic Neovim config (Neovim 0.12+, plugins via vim.pack).
-- No LSP, formatters, debuggers or language-specific setup.
--
-- Layout:
--   init.lua          options + loads the modules below
--   lua/plugins.lua   plugin list + setup   (LSP / formatter / DAP how-tos are in there)
--   lua/keybinds.lua  keymaps               (LSP / DAP keymap how-tos are in there)
--   after/ftplugin/   per-filetype overrides (see the note at the bottom of this file)

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

vim.opt.expandtab = true   
vim.opt.shiftwidth = 4     
vim.opt.tabstop = 4        
vim.opt.softtabstop = 4    

require("plugins")
require("keybinds")

vim.cmd.colorscheme("vague")

