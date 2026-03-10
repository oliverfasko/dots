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
				ensure_installed = { "basedpyright", "lua_ls" },
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

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
