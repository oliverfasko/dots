-- ~/.config/nvim/lua/keybinds.lua
local map = vim.keymap.set
local fzf = require("fzf-lua")

-- ── Insert mode ──
map("i", "jk", "<Esc>", { desc = "Exit insert mode" }) 

-- ── Normal mode: window (pane) navigation ──
map("n", "<S-h>", "<C-w>h", { desc = "Focus pane left" })
map("n", "<S-l>", "<C-w>l", { desc = "Focus pane right" })
map("n", "<S-j>", "<C-w>j", { desc = "Focus pane below" })
map("n", "<S-k>", "<C-w>k", { desc = "Focus pane above" })

-- ── Normal mode: splits ──
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })

-- ── Normal mode: leader shortcuts ──
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" }) 

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" }) 
        map("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
        map("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
        map("n", "gr", vim.lsp.buf.references, { buffer = args.buf, desc = "Go to references" })
        map("n", "gI", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Go to implementation" })
        map("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "Hover docs" })
    end,
})

-- ── Diagnostics (errors/warnings) ──
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dl", fzf.diagnostics_document, { desc = "Buffer diagnostics list" })
map("n", "<leader>dw", fzf.diagnostics_workspace, { desc = "Workspace diagnostics list" })

-- ── Visual mode ──
map("v", "<", "<gv", { desc = "Outdent, keep selection" })          
map("v", ">", ">gv", { desc = "Indent, keep selection" })           
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" }) 
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })   

