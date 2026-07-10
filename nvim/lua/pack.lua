vim.pack.add({
    "https://github.com/bluz71/vim-moonfly-colors",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
})

local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Open explorer at current file" })

require("mini.notify").setup({
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})

require("mini.cmdline").setup({ autocorrect = { enable = false } })

require("mini.surround").setup()

local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

vim.keymap.set("n", "<leader>f", function() MiniPick.builtin.files() end, { desc = "Find file" })
vim.keymap.set("n", "<leader>g", function() MiniPick.builtin.grep_live() end, { desc = "Grep in files" })
vim.keymap.set("n", "<leader>ff", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>b", function() MiniExtra.pickers.buffers() end, { desc = "Buffer list" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })

require("mini.completion").setup({ lsp_completion = { auto_setup = true } })

local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({ snippets = { MiniSnippets.gen_loader.from_lang() } })
MiniSnippets.start_lsp_server({ match = false })

require("mini.jump2d").setup({
    spotter = require("mini.jump2d").gen_pattern_spotter("[^%s%p]+"),
    mappings = { start_jumping = "s" },
})

require("mini.comment").setup()
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Toggle comment" })

local MiniDiff = require("mini.diff")
MiniDiff.setup({ source = MiniDiff.gen_source.git({ index = false }) })

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split" })
