{pkgs, ...}: {
  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [dmenu i3status i3blocks xclip xsel autorandr maim];
    };
  };

  # Auto-detect and configure monitors
  services.autorandr.enable = true;

  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;

  # Clipboard manager
  services.clipmenu.enable = true;

  # Environment variables for proper HiDPI scaling
  environment.variables = {
    # Use fractional scaling for better results on 4K
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # X server resources and startup commands
  services.xserver.displayManager.sessionCommands = ''
    # Auto-detect DPI based on monitor
    MONITOR_WIDTH=$(${pkgs.xorg.xrandr}/bin/xrandr | grep ' connected primary' | grep -oP '\d+mm' | head -1 | grep -oP '\d+')
    MONITOR_HEIGHT=$(${pkgs.xorg.xrandr}/bin/xrandr | grep ' connected primary' | grep -oP '\d+mm' | tail -1 | grep -oP '\d+')
    RESOLUTION_WIDTH=$(${pkgs.xorg.xrandr}/bin/xrandr | grep ' connected primary' | grep -oP '\d+x\d+' | head -1 | cut -dx -f1)

    # Calculate DPI (default to 120 if detection fails)
    if [ -n "$MONITOR_WIDTH" ] && [ -n "$RESOLUTION_WIDTH" ] && [ "$MONITOR_WIDTH" -gt 0 ]; then
      DPI=$(echo "scale=0; $RESOLUTION_WIDTH * 25.4 / $MONITOR_WIDTH" | ${pkgs.bc}/bin/bc)
    else
      DPI=120
    fi

    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
    Xft.dpi: $DPI
    Xft.autohint: 0
    Xft.lcdfilter: lcddefault
    Xft.hintstyle: hintfull
    Xft.hinting: 1
    Xft.antialias: 1
    Xft.rgba: rgb
    EOF

    # Start clipboard manager
    ${pkgs.clipmenu}/bin/clipmenud &

    # Auto-configure monitors
    ${pkgs.autorandr}/bin/autorandr --change &
  '';
}
