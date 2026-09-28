{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/bundles/desktop.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # Advantage 360 Pro status CLI (layer, battery, output); firmware lives in its own repo
  home.packages = [inputs.adv360-zmk-config.packages.${pkgs.stdenv.hostPlatform.system}.adv360-status];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
