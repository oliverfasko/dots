-- ~/.config/nvim/lua/keybinds.lua
local map = vim.keymap.set
local fzf = require("fzf-lua")
local dap = require("dap")
local dapui = require("dapui")

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

-- ── Debugging (DAP / GDB) ──
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue / start debugging" })
map("n", "<leader>di", dap.step_into, { desc = "Step into" })
map("n", "<leader>do", dap.step_over, { desc = "Step over" })
map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle DAP REPL" })
map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate debug session" })
-- VSCode-style function-key aliases, same actions
map("n", "<F5>", dap.continue, { desc = "Continue / start debugging" })
map("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<F10>", dap.step_over, { desc = "Step over" })
map("n", "<F11>", dap.step_into, { desc = "Step into" })
map("n", "<F12>", dap.step_out, { desc = "Step out" })
map("n", "<S-F11>", dap.step_out, { desc = "Step out" })
map("n", "<S-F5>", dap.terminate, { desc = "Stop debugging" })
map("n", "<C-S-F5>", dap.restart, { desc = "Restart debugging" })
-- some terminals report Shift+F<n> as F<n+12> instead
map("n", "<F23>", dap.step_out, { desc = "Step out" })
map("n", "<F17>", dap.terminate, { desc = "Stop debugging" })

-- ── C/C++: build like the course (g++ -g), output main.exe next to the file ──
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function(args)
        map("n", "<leader>cb", function()
            vim.cmd.write()
            vim.cmd("split | terminal g++ -g -std=c++23 -o %:p:h/main.exe %:p")
        end, { buffer = args.buf, desc = "Build current file (g++ -g → main.exe)" })
    end,
})

-- ── Visual mode ──
map("v", "<", "<gv", { desc = "Outdent, keep selection" })          
map("v", ">", ">gv", { desc = "Indent, keep selection" })           
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" }) 
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })   

