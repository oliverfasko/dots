-- plugins.lua
-- Requires Neovim 0.12+ (vim.pack)
-- Load this from init.lua with: require("plugins")
--
-- Base config: no LSP, formatters or debuggers. The three HOW TO sections below
-- (LSP, FORMATTING, DEBUGGING) show exactly what to paste in to add them.

------------------------------------------------------------
-- Install plugins
------------------------------------------------------------
vim.pack.add({
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

  -- links
  "https://github.com/chrishrb/gx.nvim",

  -- claude
  "https://github.com/coder/claudecode.nvim",

  -- mini
  "https://github.com/nvim-mini/mini.statusline",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.hipatterns",
  "https://github.com/nvim-mini/mini.indentscope",
  "https://github.com/nvim-mini/mini.icons",

  -- file bookmarks
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  -- color scheme
  "https://github.com/vague-theme/vague.nvim",

  -- markdown
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})


------------------------------------------------------------
-- Diagnostics display (works with or without LSP)
------------------------------------------------------------
-- <leader>dd / <leader>dl / <leader>dw in keybinds.lua, or the built-in
-- ]d / [d jump keymaps.
vim.diagnostic.config({
  underline = false,
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    prefix = "■ ",
    source = "if_many",
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
-- Only parsers for the config/markup files this base config touches.
-- To add a language, append its parser name, e.g. "python", "json", "javascript",
-- "c", "cpp", "make", "rust", "go". Run :TSInstall <name> to install on demand.
require("nvim-treesitter").setup({
  ensure_installed = { "lua", "markdown", "markdown_inline" },
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
-- mini
------------------------------------------------------------
local function diag_counts()
  if not vim.diagnostic.is_enabled({ bufnr = 0 }) then return "" end
  local counts = vim.diagnostic.count(0)
  local n_err = counts[vim.diagnostic.severity.ERROR] or 0
  local n_warn = counts[vim.diagnostic.severity.WARN] or 0
  local back = "%#MiniStatuslineDevinfo#"
  return string.format("%%#DiagnosticError#E%d%s %%#DiagnosticWarn#W%d%s", n_err, back, n_warn, back)
end

require("mini.statusline").setup({
  content = {
    active = function()
      local MiniStatusline = require("mini.statusline")
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics   = diag_counts()
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location      = MiniStatusline.section_location({ trunc_width = 75 })
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end,
  },
})
require("mini.pairs").setup()
require("mini.hipatterns").setup()
require("mini.indentscope").setup({
  draw = { animation = function() return 0 end },
})

------------------------------------------------------------
-- Harpoon
------------------------------------------------------------
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<M-m>", function() harpoon:list():add() end, { desc = "Harpoon: mark file" })
vim.keymap.set("n", "<M-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: quick menu" })

vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
vim.keymap.set("n", "<M-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
vim.keymap.set("n", "<M-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
vim.keymap.set("n", "<M-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })

vim.keymap.set("n", "<M-[>", function() harpoon:list():prev() end, { desc = "Harpoon: prev" })
vim.keymap.set("n", "<M-]>", function() harpoon:list():next() end, { desc = "Harpoon: next" })

