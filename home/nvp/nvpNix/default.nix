{...}: {
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/bundles/desktop.nix
    ../../../modules/home-manager/programs/niri
    ../../../modules/home-manager/programs/rofi
  ];

  programs.home-manager.enable = true;

  # ONLY CHANGE THIS AFTER READING: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
