local themes = {
  { repo = "rose-pine/neovim", name = "rose-pine" },
  { repo = "rebelot/kanagawa.nvim", name = "kanagawa" },
  { repo = "catppuccin/nvim", name = "catppuccin" },
  { repo = "folke/tokyonight.nvim", name = "tokyonight" },
  { repo = "morhetz/gruvbox" },
}

return {
  -- Generate plugin specs from themes table
  (function()
    local plugins = {}
    for _, theme in ipairs(themes) do
      if theme.name then
        table.insert(plugins, { theme.repo, name = theme.name })
      else
        table.insert(plugins, theme.repo)
      end
    end
    return plugins
  end)(),

  -- Theme switcher setup
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      local theme_names = {}
      for _, theme in ipairs(themes) do
        table.insert(theme_names, theme.name or theme.repo:match("/([^/.]+)"))
      end
      require("themery").setup({
        themes = theme_names,
      })
    end,
  },
}
