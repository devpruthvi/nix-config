-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlight on Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Auto center on <C-u/C-d>
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("UserTextYankHighlightGroup", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set("n", "<leader>pv", "<Cmd>Oil<CR>")

local wk = require("which-key")

-- Gitsigns, Fugitive
wk.add({
    { "<leader>g", group = "Git" },
    { "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<CR>", desc = "Blame Line" },
    { "<leader>gf", "<cmd>lua vim.cmd.Git()<CR>", desc = "Fugitive" },
    { "<leader>gn", "<cmd>lua require('gitsigns').next_hunk()<CR>", desc = "Goto Next Hunk" },
    { "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<CR>", desc = "Preview Hunk" },
    { "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<CR>", desc = "Reset Hunk" },
    { "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<CR>", desc = "Stage Hunk" },
    { "<leader>gu", "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", desc = "Undo Stage Hunk" },
})

-- Bufferline
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLinePick<CR>")
