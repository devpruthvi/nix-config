local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_background_opacity = 0.87
config.macos_window_background_blur = 20

function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Catppuccin Latte"
  end
end

-- tab bar theme
local bar = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
bar.setup({
  sections = {
    tabline_a = {},
    tabline_b = {},
    tabline_c = {},
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {},
    tabline_y = { 'datetime' },
    tabline_z = { 'hostname' },
  },
})
bar.apply_to_config(config)

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

return config