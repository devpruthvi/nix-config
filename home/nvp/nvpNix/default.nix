{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../modules/home-manager/common
    ../../../modules/home-manager/bundles/desktop.nix
    ../../../modules/home-manager/programs/dsh
    ../../../modules/home-manager/programs/niri
    ../../../modules/home-manager/programs/rofi
    ../../../modules/home-manager/programs/yazi
  ];

  programs.home-manager.enable = true;

  # gitFull ships git-credential-libsecret; creds live in gnome-keyring, unlocked at login.
  programs.git = {
    package = pkgs.gitFull;
    settings.credential.helper = "libsecret";
  };

  # Automount removable drives under /run/media/nvp with a notification
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  # Advantage 360 Pro status CLI (layer, battery, output); firmware lives in its own repo
  home.packages = [inputs.adv360-zmk-config.packages.${pkgs.stdenv.hostPlatform.system}.adv360-status];

  # ONLY CHANGE THIS AFTER READING: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
