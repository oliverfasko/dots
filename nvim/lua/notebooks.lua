-- notebooks.lua: Jupyter notebooks in Neovim
-- jupytext.nvim  : open .ipynb as plain text ("# %%" cells), saves back to .ipynb
-- molten-nvim    : run cells on a real Jupyter kernel, output inline
-- image.nvim     : inline plots via the kitty graphics protocol
-- NotebookNavigator : cell text objects / run cell / jump between cells
-- Python deps live in ~/.venvs/nvim (pynvim, jupyter_client, jupytext, ipykernel)

--[[ KEYBIND CHEAT SHEET  (also: :JupyterKeys)
  Run
    <leader>jr   run cell            (visual: run selection)
    <leader>jn   run cell + move to next   (also <S-CR>)
    <leader>jR   run all cells
    <leader>jl   run current line
  Navigate / edit cells
    ]j / [j      next / previous cell
    <leader>ja   add cell below      <leader>jA  add cell above
    <leader>jm   merge with cell below
  Output
    <leader>jo   open output window  <leader>jh  hide output
    <leader>jd   delete cell output
  Kernel
    <leader>ji   start kernel (nvim) <leader>jI  pick kernel
    <leader>jx   restart kernel      <leader>jq  stop kernel
]]

local venv = vim.fn.expand("~/.venvs/nvim")
vim.g.python3_host_prog = venv .. "/bin/python"

-- molten is a remote plugin: re-register it whenever it is installed/updated
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "molten-nvim" and ev.data.kind ~= "delete" then
      if not ev.data.active then vim.cmd.packadd("molten-nvim") end
      vim.cmd("UpdateRemotePlugins")
    end
  end,
})

vim.pack.add({
  "https://github.com/GCBallesteros/jupytext.nvim",
  "https://github.com/benlubas/molten-nvim",
  "https://github.com/3rd/image.nvim",
  "https://github.com/GCBallesteros/NotebookNavigator.nvim",
})

require("jupytext").setup({
  style = "percent",
  output_extension = "auto",
  force_ft = "python",
})

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = true,
})

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_auto_open_output = false
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true
vim.g.molten_wrap_output = true
vim.g.molten_output_win_max_height = 20

local nn = require("notebook-navigator")
nn.setup({
  activate_hydra_keys = nil,
  repl_provider = "molten",
  syntax_highlight = true,
})

-- start a kernel automatically the first time you run a cell
local function run_cell() 
  if not pcall(function() return vim.fn.MoltenRunningKernels(true)[1] end)
     or #vim.fn.MoltenRunningKernels(true) == 0 then
    vim.cmd("MoltenInit nvim")
  end
end

local map = vim.keymap.set
map("n", "<leader>ji", "<cmd>MoltenInit nvim<cr>", { desc = "Jupyter: start kernel" })
map("n", "<leader>jI", "<cmd>MoltenInit<cr>", { desc = "Jupyter: pick kernel" })
map("n", "<leader>jx", "<cmd>MoltenRestart!<cr>", { desc = "Jupyter: restart kernel" })
map("n", "<leader>jq", "<cmd>MoltenDeinit<cr>", { desc = "Jupyter: stop kernel" })
map("n", "<leader>jr", function() run_cell(); nn.run_cell() end, { desc = "Run cell" })
map("n", "<leader>jn", function() run_cell(); nn.run_and_move() end, { desc = "Run cell and move next" })
map("n", "<leader>jR", function() run_cell(); nn.run_all_cells() end, { desc = "Run all cells" })
map("n", "<S-CR>", function() run_cell(); nn.run_and_move() end, { desc = "Run cell and move next" })
map("n", "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", { desc = "Run line" })
map("v", "<leader>jr", ":<C-u>MoltenEvaluateVisual<cr>gv", { desc = "Run selection", silent = true })
map("n", "<leader>jo", "<cmd>MoltenEnterOutput<cr>", { desc = "Open output window" })
map("n", "<leader>jh", "<cmd>MoltenHideOutput<cr>", { desc = "Hide output" })
map("n", "<leader>jd", "<cmd>MoltenDelete<cr>", { desc = "Delete cell output" })
map("n", "]j", function() nn.move_cell("d") end, { desc = "Next cell" })
map("n", "[j", function() nn.move_cell("u") end, { desc = "Previous cell" })
map("n", "<leader>ja", function() nn.add_cell_below() end, { desc = "Add cell below" })
map("n", "<leader>jA", function() nn.add_cell_above() end, { desc = "Add cell above" })
map("n", "<leader>jm", function() nn.merge_cell("d") end, { desc = "Merge cell with below" })

vim.api.nvim_create_user_command("JupyterKeys", function()
  local src = vim.fn.readfile(vim.fn.stdpath("config") .. "/lua/notebooks.lua")
  local out = {}
  for i = 2, #src do
    if src[i]:match("^%]%]") then break end
    out[#out + 1] = src[i]
  end
  vim.cmd("botright new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.modifiable = "nofile", "wipe", false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
end, { desc = "Show notebook keybind cheat sheet" })
