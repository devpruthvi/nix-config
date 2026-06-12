return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- group labels belong in opts.spec (the old `keys = {...}` form was
    -- silently ignored — `keys` is lazy.nvim's keymap field)
    spec = {
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>g", group = "[G]it" },
      { "<leader>h", group = "[H]arpoon" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>S", group = "[S]ession" },
      { "<leader>w", group = "[W]orkspace" },
    },
  },
}
