local wezterm = require("wezterm")

-- Allow requiring modules from an optional machine-local overlay
-- (~/.config/nix-local/wezterm), managed outside this repo, e.g. a work config.
package.path = (os.getenv("HOME") or "") .. "/.config/nix-local/wezterm/?.lua;" .. package.path

local config = wezterm.config_builder()

config.window_background_opacity = 0.87
config.macos_window_background_blur = 20

config.font = wezterm.font "Iosvmata"

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

-- Machine-local overrides: ~/.config/nix-local/wezterm/work.lua, if present,
-- returns a function that mutates `config`. Absent -> no-op.
local ok, work = pcall(require, "work")
if ok and type(work) == "function" then
  work(config, wezterm)
end

return config
