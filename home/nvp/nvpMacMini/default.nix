{hmModules, ...}: {
  imports = [
    "${hmModules}/common"
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
