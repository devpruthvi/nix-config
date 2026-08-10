{
  config,
  pkgs,
  dotfilesDir,
  ...
}: {
  # Config is nix-generated so the focus-ring colors track the stylix base16
  # scheme (stylix has no niri target). Editing needs a rebuild; niri then
  # hot-reloads the new store file.
  xdg.configFile."niri/config.kdl".text = ''
    // niri config: i3 muscle-memory with vim-style hjkl.

    input {
        mod-key "Alt"
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
        focus-follows-mouse
        warp-mouse-to-focus
    }

    layout {
        gaps 8
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 2
            active-color "#${config.lib.stylix.colors.base0E}"
            inactive-color "#${config.lib.stylix.colors.base02}"
        }
        border {
            off
        }
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    hotkey-overlay {
        skip-at-startup
    }

    // X11 apps run through xwayland-satellite on :0.
    environment {
        DISPLAY ":0"
    }

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "sh" "-c" "wl-paste --watch cliphist store"

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Launchers
        Mod+Return repeat=false { spawn "ghostty"; }
        Mod+D repeat=false { spawn "fuzzel"; }
        Mod+Shift+V repeat=false { spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }

        // Window / column management
        Mod+Shift+Q { close-window; }
        Mod+F { fullscreen-window; }
        Mod+Shift+M { maximize-column; }
        Mod+C { center-column; }
        Mod+Shift+Space { toggle-window-floating; }
        Mod+Space { switch-focus-between-floating-and-tiling; }

        // Focus (hjkl)
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+Home { focus-column-first; }
        Mod+End { focus-column-last; }

        // Move / swap (Shift+hjkl)
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        // Merge/split columns (niri's scrollable-tiling extras)
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Column sizing
        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Workspaces (i3-style numbers)
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Ctrl+J { focus-workspace-down; }
        Mod+Ctrl+K { focus-workspace-up; }
        Mod+Tab { toggle-overview; }

        // Monitors
        Mod+Ctrl+H { focus-monitor-left; }
        Mod+Ctrl+L { focus-monitor-right; }
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

        // Media / brightness
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
        XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

        // Screenshots
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Session
        Super+Alt+L { spawn "swaylock"; }
        Mod+Shift+E { quit; }
    }
  '';

  # Waybar stays a live-editable symlink.
  xdg.configFile."waybar".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/waybar";

  home.packages = with pkgs; [
    waybar
    fuzzel
    mako
    swaylock
    swayidle
    swaybg
    wl-clipboard
    cliphist
    grim
    slurp
    brightnessctl
    playerctl
    xwayland-satellite
  ];
}
