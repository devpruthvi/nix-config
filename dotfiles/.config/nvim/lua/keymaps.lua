-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlight on Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Auto center on <C-u/C-d>
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Diagnostic keymaps
-- Note: [d / ]d (vim.diagnostic.jump) are built-in defaults since 0.11
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window/tmux navigation (<C-h/j/k/l>) is set up in plugins/nvim-tmux.lua

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("UserTextYankHighlightGroup", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.keymap.set("n", "<leader>pv", "<Cmd>Oil<CR>")

local wk = require("which-key")

-- Gitsigns, Fugitive
wk.add({
  { "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<CR>", desc = "Blame Line" },
  { "<leader>gf", "<cmd>lua vim.cmd.Git()<CR>", desc = "Fugitive" },
  { "<leader>gn", "<cmd>lua require('gitsigns').nav_hunk('next')<CR>", desc = "Goto Next Hunk" },
  { "<leader>gN", "<cmd>lua require('gitsigns').nav_hunk('prev')<CR>", desc = "Goto Previous Hunk" },
  { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<CR>", desc = "Preview Hunk" },
  { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<CR>", desc = "Reset Hunk" },
  -- stage_hunk toggles: staging an already-staged hunk un-stages it
  { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<CR>", desc = "Stage/Unstage Hunk" },
})

-- Bufferline
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLinePick<CR>")
