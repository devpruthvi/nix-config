{
  pkgs,
  hostname,
  ...
}: {
  networking.computerName = "${hostname}";
  networking.hostName = "${hostname}";

  system.defaults = {
    dock = {
      "show-recents" = false;
      "autohide" = true;
      "autohide-delay" = 1000.0; # large delay to 'disable' dock
      "autohide-time-modifier" = 0.0;
      "orientation" = "left";
      "tilesize" = 40; # smaller icon size (default = 64)

      # Group windows by application in Mission Control
      "expose-group-apps" = true;

      # Hot Corners (wvous-*-corner)
      # 0 = no action, 1 = disabled, 2 = Mission Control, 3 = Application Windows, 4 = Desktop, 5 = Start Screen Saver, 6 = Disable Screen Saver, 7 = Dashboard, 10 = Put Display to Sleep, 11 = Launchpad, 12 = Notification Center
      "wvous-tl-corner" = 1;
      "wvous-tr-corner" = 1;
      "wvous-bl-corner" = 1;
      "wvous-br-corner" = 1;
    };

    finder = {
      # Always show hidden files
      "AppleShowAllFiles" = true;

      # Always show file extensions
      "AppleShowAllExtensions" = true;

      # Show status bar at bottom of finder windows with item/disk space stats
      "ShowStatusBar" = true;

      # Show path breadcrumbs in finder windows
      "ShowPathbar" = true;

      # Show the full POSIX filepath in the window title
      "_FXShowPosixPathInTitle" = true;

      # When performing a search, search the current folder by default
      "FXDefaultSearchScope" = "SCcf";

      # Disable the warning when changing a file extension
      "FXEnableExtensionChangeWarning" = false;

      # Use list view in all Finder windows by default
      "FXPreferredViewStyle" = "Nlsv";
    };

    CustomUserPreferences = {
      "NSGlobalDomain" = {
        # Move windows by dragging any part of the window (ctrl+cmd)
        NSWindowShouldDragOnGesture = true;

        # Disable window optning animations
        NSAutomaticWindowAnimationsEnabled = false;
      };

      # Disable 'Displys have separate spaces'
      "com.apple.spaces"."spans-displays" = false;
    };

    "NSGlobalDomain" = {
      # Don't show the top bar unless moused over
      _HIHideMenuBar = true;

      # Disable autocorrect
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  # Add ability to use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
