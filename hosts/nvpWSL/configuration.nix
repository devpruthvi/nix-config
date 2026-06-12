{
  config,
  lib,
  pkgs,
  inputs,
  nixosModules,
  hostname,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    "${nixosModules}/common"
    "${nixosModules}/desktop/i3"
  ];

  wsl.enable = true;
  wsl.defaultUser = "nvp";
  wsl.interop.includePath = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Launch i3 against the VcXsrv X server running on the Windows host
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "start-i3" ''
      # 1. Nuke all Wayland references
      unset WAYLAND_DISPLAY
      unset WAYLAND_SOCKET

      # 2. Force UI toolkits to strictly use X11
      export GDK_BACKEND=x11
      export QT_QPA_PLATFORM=xcb
      export SDL_VIDEODRIVER=x11
      export WINIT_UNIX_BACKEND=x11

      export DISPLAY=$(${pkgs.iproute2}/bin/ip route show default | ${pkgs.gawk}/bin/awk '{print $3}'):1
      exec i3
    '')
  ];

  # Networking
  networking.hostName = hostname;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # DO NOT CHANGE THIS DURING UPGRADE - Did you read the comment?
}
