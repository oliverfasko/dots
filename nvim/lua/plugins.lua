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
  "https://github.com/b0o/SchemaStore.nvim",
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.0") },

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
  "https://github.com/sindrets/diffview.nvim",

  -- formatting
  "https://github.com/stevearc/conform.nvim",

  -- links
  "https://github.com/chrishrb/gx.nvim",

  -- claude
  "https://github.com/coder/claudecode.nvim",

  -- qol
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-mini/mini.statusline",

  -- file bookmarks
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  --color scheme
  "https://github.com/vague-theme/vague.nvim"
})

------------------------------------------------------------
-- Mason
------------------------------------------------------------
require("mason").setup()

------------------------------------------------------------
-- Completion
------------------------------------------------------------
require("blink.cmp").setup({
  -- <C-space>: trigger/open docs, <CR>: accept, <Tab>/<S-Tab>: next/prev,
  -- <C-n>/<C-p>: next/prev, <C-e>: hide, <C-k>: toggle signature help.
  keymap = { preset = "default" },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = { border = "single" },
  },
  signature = { enabled = true, window = { border = "single" } },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

------------------------------------------------------------
-- LSP
------------------------------------------------------------
-- Ruff
vim.lsp.config.ruff = {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".git" },
}

-- basedpyright
vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
}

-- JSON 
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

-- JS 
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
   virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    prefix = '■ ', 
    source = 'if_many', 
  },
  signs = { 
        active = true,
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN]  = "W",
          [vim.diagnostic.severity.HINT]  = "H",
          [vim.diagnostic.severity.INFO]  = "I",
        },
    },
  severity_sort = true,
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
    virt_text_pos = "eol", 
    delay = 300,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle line blame" })
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Blame popup (full commit)" })

require("neogit").setup({})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

require("diffview").setup({})
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history (timeline)" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
vim.keymap.set("v", "<leader>gh", ":DiffviewFileHistory<cr>", { desc = "File history for selection" })

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
-- Harpoon
---------------------------------------------------------------
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: quick menu" })

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })
