require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("pack")
require("treesitter")
require("lsp")
require("debug")

require("gruvbox").setup({ contrast = "hard" })
vim.cmd.colorscheme("gruvbox")
