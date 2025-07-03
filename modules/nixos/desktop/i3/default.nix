{pkgs, ...}: {
  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [dmenu i3status i3blocks xclip];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;
}
