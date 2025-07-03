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
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

return config