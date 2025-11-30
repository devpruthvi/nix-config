{hmModules, ...}: {
  imports = [
    "${hmModules}/common"
  ];

  programs.home-manager.enable = true;

  # ONLY CHANGE THIS AFTER READING: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
