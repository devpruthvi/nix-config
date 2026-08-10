{pkgs, ...}: {
  # nixpkgs module installs niri, registers its Wayland session, portals, keyring.
  programs.niri.enable = true;

  # greetd + tuigreet on a VT (most reliable greeter on NVIDIA) launching niri-session.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri-session";
      user = "greeter";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # niri has no built-in XWayland; xwayland-satellite is spawned from the niri config.
  environment.systemPackages = [pkgs.xwayland-satellite];
}
