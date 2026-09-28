{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common
    ../../modules/nixos/desktop/niri
    ../../modules/nixos/llm/llamacpp.nix
    ../../modules/nixos/llm/llm-agents.nix
    ../../modules/nixos/virtualisation/docker.nix
  ];

  # Networking
  networking.hostName = hostname;

  # Keep RTC in local time for dual-booting with Windows, sync via NTP
  time.hardwareClockInLocalTime = true;
  services.timesyncd.enable = true;
  time.timeZone = lib.mkForce "America/Los_Angeles";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Let adv360-status read the Advantage 360 Pro's raw HID status over USB and Bluetooth
  services.udev.packages = [
    (pkgs.writeTextDir "lib/udev/rules.d/70-adv360.rules" ''
      KERNEL=="hidraw*", KERNELS=="*:1D50:615E.*", TAG+="uaccess"
    '')
  ];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

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
