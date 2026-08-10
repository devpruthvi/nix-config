# Reusable system/home builders.
#
# These are factored out of `flake.nix` so that *other* flakes (e.g. a private
# work overlay) can import this flake and call `personal.lib.mkDarwin`/`mkHome`
# to define their own hosts while reusing this flake's pinned inputs, overlays
# and modules. Every builder accepts `extraModules` / `extraHomeModules` seams
# for layering machine-specific config that is not tracked in this repo.
{
  inputs,
  outputs,
}: let
  inherit
    (inputs)
    nixpkgs
    darwin
    home-manager
    nix-homebrew
    homebrew-core
    homebrew-cask
    homebrew-barutsrb
    mac-app-util
    ;

  lib = nixpkgs.lib;

  # Default identity for this repo's owner. A wrapping flake can pass its own
  # `userConfig` (e.g. a work email) to any builder.
  defaultUserConfig = {
    email = "pruthvi.n.v@gmail.com";
    fullName = "Pruthvi Raj N V";
    name = "nvp";
  };

  baseOverlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.unstable-packages
  ];

  # nixpkgs instance with this repo's overlays + unfree allowed. Used by the
  # standalone home-manager builder (system configs get pkgs from their module).
  # `extraOverlays` lets a wrapping flake inject work-specific package overrides
  # (e.g. `.override`, version pins, swaps) into the standalone-home pkgs set,
  # where `nixpkgs.overlays` module options are ignored (pkgs is passed in).
  pkgsFor = system: extraOverlays:
    import nixpkgs {
      inherit system;
      overlays = baseOverlays ++ extraOverlays;
      config.allowUnfree = true;
    };

  # Live (out-of-store) location of the checked-out dotfiles, used for
  # mkOutOfStoreSymlink so configs stay editable without a rebuild.
  dotfilesDirFor = system: username:
    "/${
      if lib.hasSuffix "darwin" system
      then "Users"
      else "home"
    }/${username}/nix-config/dotfiles";
in rec {
  inherit defaultUserConfig;

  # NixOS host, with home-manager wired in so `nixos-rebuild switch` also
  # activates the per-host home entrypoint. Mirrors mkDarwin's seams.
  mkNixos = {
    hostname,
    system ? "x86_64-linux",
    username ? defaultUserConfig.name,
    userConfig ? defaultUserConfig,
    extraModules ? [],
    extraHomeModules ? [],
    localDotfilesDir ? null,
    # Work-specific package overrides. Merged with the repo's overlays.
    overlays ? [],
  }: let
    hostModule = ../hosts/${hostname}/configuration.nix;
    homeModule = ../home/${username}/${hostname}/default.nix;
  in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname userConfig;
      };
      modules =
        lib.optional (builtins.pathExists hostModule) hostModule
        ++ lib.optional (overlays != []) {nixpkgs.overlays = overlays;}
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {
                inherit inputs outputs userConfig localDotfilesDir;
                dotfilesDir = dotfilesDirFor system username;
              };
              users.${username}.imports =
                lib.optional (builtins.pathExists homeModule) homeModule
                ++ extraHomeModules;
            };
          }
        ]
        ++ extraModules;
    };

  # nix-darwin host, with home-manager wired in. The per-host home entrypoint
  # (`home/<username>/<hostname>/default.nix`) is imported when present; extra
  # (out-of-repo) home config layers via `extraHomeModules`.
  mkDarwin = {
    hostname,
    system ? "aarch64-darwin",
    username ? defaultUserConfig.name,
    userConfig ? defaultUserConfig,
    extraModules ? [],
    extraHomeModules ? [],
    localDotfilesDir ? null,
    # Work-specific package overrides. Applied at the darwin nixpkgs level, so
    # they flow to home too (home-manager uses useGlobalPkgs here).
    overlays ? [],
  }: let
    hostModule = ../hosts/${hostname};
    homeModule = ../home/${username}/${hostname}/default.nix;
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs hostname userConfig;
      };
      modules =
        lib.optional (builtins.pathExists hostModule) hostModule
        ++ lib.optional (overlays != []) {nixpkgs.overlays = overlays;}
        ++ [
          home-manager.darwinModules.home-manager
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = username;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "barutsrb/homebrew-tap" = homebrew-barutsrb;
              };
              mutableTaps = false;
              autoMigrate = true;
            };

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {
                inherit inputs outputs userConfig localDotfilesDir;
                dotfilesDir = dotfilesDirFor system username;
              };
              users.${username}.imports =
                lib.optional (builtins.pathExists homeModule) homeModule
                ++ [mac-app-util.homeManagerModules.default]
                ++ extraHomeModules;
            };
          }
        ]
        ++ extraModules;
    };

  # Standalone home-manager configuration. The per-host home entrypoint is
  # imported when present; out-of-repo home config layers via `extraHomeModules`.
  mkHome = {
    hostname,
    system ? "x86_64-linux",
    username ? defaultUserConfig.name,
    userConfig ? defaultUserConfig,
    extraHomeModules ? [],
    localDotfilesDir ? null,
    # Work-specific package overrides. Baked into the pkgs set (nixpkgs.overlays
    # module options are ignored for standalone home-manager).
    overlays ? [],
  }: let
    homeModule = ../home/${username}/${hostname}/default.nix;
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system overlays;
      extraSpecialArgs = {
        inherit inputs outputs userConfig localDotfilesDir;
        dotfilesDir = dotfilesDirFor system username;
      };
      modules =
        lib.optional (builtins.pathExists homeModule) homeModule
        ++ extraHomeModules
        ++ lib.optionals (lib.hasSuffix "darwin" system) [
          mac-app-util.homeManagerModules.default
        ];
    };
}
