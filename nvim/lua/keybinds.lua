-- ~/.config/nvim/lua/keybinds.lua
--

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

-- <S-w> -> :bclose  (close buffer without closing the split/window it's in)
map("n", "<S-w>", function()
    local cur = vim.api.nvim_get_current_buf()
    local alt = vim.fn.bufnr("#")
    if alt ~= -1 and alt ~= cur and vim.fn.buflisted(alt) == 1 then
        vim.cmd("buffer #")
    else
        local listed = vim.tbl_filter(function(b)
            return vim.fn.buflisted(b) == 1 and b ~= cur
        end, vim.api.nvim_list_bufs())
        if #listed > 0 then
            vim.cmd("buffer " .. listed[1])
        else
            vim.cmd("enew")
        end
    end
    if vim.api.nvim_buf_is_valid(cur) then
        vim.cmd("bdelete " .. cur)
    end
end, { desc = "Close buffer, keep window layout" })

-- ── Normal mode: leader shortcuts ──
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" }) -- <leader>h -> :nohl
map("n", "<leader>f", fzf.files, { desc = "Find files" })                        -- <leader>f -> quickOpen
map("n", "<leader>g", fzf.live_grep, { desc = "Find in files" })                 -- <leader>g -> findInFiles
map("n", "<leader>b", fzf.buffers, { desc = "Show all buffers" })                -- <leader>b -> showAllEditors

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" }) -- editor.action.quickFix
    end,
})

-- ── Diagnostics (errors/warnings) ──
-- ]d / [d / ]D / [D to jump between them are Neovim 0.11+ built-ins.
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dl", fzf.diagnostics_document, { desc = "Buffer diagnostics list" })
map("n", "<leader>dw", fzf.diagnostics_workspace, { desc = "Workspace diagnostics list" })

-- ── Visual mode ──
map("v", "<", "<gv", { desc = "Outdent, keep selection" })          -- editor.action.outdentLines
map("v", ">", ">gv", { desc = "Indent, keep selection" })           -- editor.action.indentLines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" }) -- editor.action.moveLinesDownAction
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })   -- editor.action.moveLinesUpAction
map("v", "<leader>c", "gc", { desc = "Toggle comment", remap = true }) -- editor.action.commentLine (native gc, Neovim 0.10+)

