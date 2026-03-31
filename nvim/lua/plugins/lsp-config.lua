return {
	-- MASON
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	-- mason-lspconfig
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "basedpyright", "lua_ls", "clangd"},
			})
		end,
	},
	-- masontoolinstaller
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"isort",
					"ruff",
					"shellcheck",
					"shfmt",
				},
			})
		end,
	},
	-- nvim lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					intelephense = {
						diagnostics = {
							undefinedTypes = false,
							undefinedFunctions = true,
							undefinedConstants = true,
							undefinedClassConstants = true,
							undefinedMethods = true,
							undefinedProperties = true,
							undefinedVariables = true,
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "recommended",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})
			vim.lsp.enable("basedpyright")

			vim.lsp.config("clangd", {
				cmd = { "clangd" },
				filetypes = { "c", "cpp" },
				root_markers = {
					"compile_commands.json",
					"compile_flags.txt",
					".git",
				},
			})

			vim.lsp.enable("clangd")

			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
				settings = {
					bashIde = {
						globPattern = "*@(.sh|.inc|.bash|.command)",
					},
				},
			})
			vim.lsp.enable("bashls")

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
