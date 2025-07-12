return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("TransparentEnable")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {},
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
}
