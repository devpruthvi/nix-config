{pkgs, ...}: {
  # Install yazi via home-manager module
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    # M opens a mount/unmount/eject panel (udisks on Linux, diskutil on macOS)
    plugins.mount = pkgs.yaziPlugins.mount;
    keymap.mgr.prepend_keymap = [
      {
        on = "M";
        run = "plugin mount";
        desc = "Mount manager";
      }
    ];
  };

  # Enable stylix theming for yazi.
  stylix.targets.yazi.enable = true;
}
