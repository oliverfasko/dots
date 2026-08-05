-- plugins.lua
-- Requires Neovim 0.12+ (vim.pack)
-- Load this from init.lua with: require("plugins")

------------------------------------------------------------
-- Install plugins
------------------------------------------------------------
vim.pack.add({
  -- LSP / completion
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/saghen/blink.lib", -- required by blink.cmp v2 (main)
  "https://github.com/saghen/blink.cmp",
  "https://github.com/b0o/SchemaStore.nvim",

  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- file explorer
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",

  -- fuzzy finder
  "https://github.com/ibhagwan/fzf-lua",

  -- git
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/NeogitOrg/neogit",

  -- formatting
  "https://github.com/stevearc/conform.nvim",

  -- links
  "https://github.com/chrishrb/gx.nvim",

  -- claude
  "https://github.com/coder/claudecode.nvim",

  -- qol
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-mini/mini.statusline",

  -- motion (vim.sneak parity, nothing else here covers 2-char jump)
  "https://github.com/folke/flash.nvim",

  --color scheme
  "https://github.com/vague-theme/vague.nvim"
})

------------------------------------------------------------
-- Mason (just for installing LSP/tool binaries)
------------------------------------------------------------
require("mason").setup()

------------------------------------------------------------
-- LSP
------------------------------------------------------------
-- Ruff: linting + import sorting. Reads pyproject.toml automatically.
vim.lsp.config.ruff = {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".git" },
}

-- basedpyright: type checking (ruff doesn't do this)
vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", ".git" },
}

-- JSON with schema validation
vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- Markdown
vim.lsp.config.marksman = {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".git" },
}

-- JS (rare use, kept minimal)
vim.lsp.config.vtsls = {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", ".git" },
}

vim.lsp.enable({ "ruff", "basedpyright", "jsonls", "marksman", "vtsls" })

-- <leader>dd / <leader>dl / <leader>dw in keybinds.lua, or the built-in
-- ]d / [d jump keymaps).
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = false,
  severity_sort = true,
})

------------------------------------------------------------
-- Completion
------------------------------------------------------------
-- v2's native fuzzy matcher needs either a Rust toolchain (to build) or a
-- tagged release (to download a prebuilt binary) -- neither is available
-- here (no cargo, and v2 hasn't cut a release tag yet on main). Explicitly
-- use the bundled pure-Lua matcher instead of "prefer_rust_with_warning",
-- so it's a deliberate, warning-free choice rather than a silent fallback.
require("blink.cmp").setup({
  keymap = { preset = "default" },
  fuzzy = { implementation = "lua" },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
})

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
require("nvim-treesitter").setup({
  ensure_installed = { "python", "json", "javascript", "markdown", "markdown_inline", "lua" },
  highlight = { enable = true },
})
require("treesitter-context").setup()

------------------------------------------------------------
-- File explorer
------------------------------------------------------------
require("neo-tree").setup({
  filesystem = {
    follow_current_file = { enabled = true },
    filtered_items = { hide_dotfiles = false, hide_gitignored = false },
  },
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

------------------------------------------------------------
-- Fuzzy finder
------------------------------------------------------------
local fzf = require("fzf-lua")
fzf.setup({})
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document symbols" })

------------------------------------------------------------
-- Git
------------------------------------------------------------
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- blame shown at end of line
    delay = 300,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Blame popup (full commit)" })

require("neogit").setup({})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

------------------------------------------------------------
-- Formatting
------------------------------------------------------------
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

------------------------------------------------------------
-- Link opening
------------------------------------------------------------
require("gx").setup({})

------------------------------------------------------------
-- Claude Code
------------------------------------------------------------
require("claudecode").setup()
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })

------------------------------------------------------------
-- QoL
------------------------------------------------------------
require("which-key").setup({})
require("mini.statusline").setup({})

------------------------------------------------------------
-- Motion: s / S sneak-style 2-char jump (vim.sneak: true)
------------------------------------------------------------
require("flash").setup()
