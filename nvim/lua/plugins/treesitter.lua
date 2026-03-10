return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup({
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"json",
        "python",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
			},
		})
    
		callback = function()
			-- syntax highlighting, provided by Neovim
			vim.treesitter.start()
			-- folds, provided by Neovim (I don't like folds)
			-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			-- vim.wo.foldmethod = 'expr'
			-- indentation, provided by nvim-treesitter
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
}
