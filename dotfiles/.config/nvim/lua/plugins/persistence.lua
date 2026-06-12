return {
  -- Automatic per-directory sessions. Saved on exit, restored from the
  -- dashboard ("s") or the keymaps below. Pairs with tmux-resurrect:
  -- resurrect restores the tmux layout + nvim in its cwd, persistence
  -- restores the editor state for that cwd.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>Ss", function() require("persistence").load() end, desc = "Restore [S]ession (cwd)" },
      { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore [L]ast Session" },
      { "<leader>Sp", function() require("persistence").select() end, desc = "[P]ick Session" },
      { "<leader>Sd", function() require("persistence").stop() end, desc = "[D]on't Save Current Session" },
    },
  },
}
