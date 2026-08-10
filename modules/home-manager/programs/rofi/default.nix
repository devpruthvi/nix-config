{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
    };
  };

  # Colors, fonts and opacity come from the shared base16 scheme.
  stylix.targets.rofi.enable = true;
}
