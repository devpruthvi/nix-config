return {
  "folke/ts-comments.nvim",
  dependencies = {
    { "numToStr/Comment.nvim", opts = {} },
  },
  opts = {},
  event = "VeryLazy",
  enabled = vim.fn.has("nvim-0.10.0") == 1,
}
