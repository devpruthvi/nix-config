{
  description = "nvp's Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Fix Nix installed apps on Mac
    mac-app-util.url = "github:hraban/mac-app-util";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No nixpkgs follows: keeps its own pin so the numtide cache hits.
    llm-agents.url = "github:numtide/llm-agents.nix";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-barutsrb = {
      url = "github:barutsrb/homebrew-tap";
      flake = false;
    };
  };

  outputs = {
    self,
    stylix,
    nixpkgs,
    darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-barutsrb,
    mac-app-util,
    nixos-wsl,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Reusable system/home builders (mkNixos / mkDarwin / mkHome). Exposed as
    # `outputs.lib` so a private overlay flake can reuse them for its own hosts.
    mkConfigs = import ./lib/builders.nix {inherit inputs outputs;};
    inherit (mkConfigs) mkNixos mkDarwin mkHome;
  in {
    # Builders, re-exported so wrapping flakes can `personal.lib.mkDarwin {...}`.
    lib = mkConfigs;

    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable module aggregators, exported so a wrapping flake can compose them
    # (e.g. `imports = [ personal.homeManagerModules.default ];`).
    nixosModules.default = import ./modules/nixos/common;
    darwinModules.default = import ./modules/darwin;

    # `default` = the CLI core aggregate; `desktop` = the full opt-in GUI bundle;
    # and every program under modules/home-manager/programs/ is exposed by its
    # own name, so a wrapping flake can pick apps à la carte, e.g.
    #   imports = [ personal.homeManagerModules.wezterm ];
    homeManagerModules =
      {
        default = import ./modules/home-manager/common;
        desktop = import ./modules/home-manager/bundles/desktop.nix;
      }
      // (let
        programsDir = ./modules/home-manager/programs;
        names =
          builtins.attrNames
          (nixpkgs.lib.filterAttrs (_: t: t == "directory") (builtins.readDir programsDir));
      in
        nixpkgs.lib.genAttrs names (name: programsDir + "/${name}"));

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nvpNix = mkNixos {hostname = "nvpNix";};
      nvpWSL = mkNixos {hostname = "nvpWSL";};
      "nvp-vm" = mkNixos {hostname = "nvp-vm";};
    };

    darwinConfigurations = {
      "nvpMacMini" = mkDarwin {hostname = "nvpMacMini";};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "nvp@nvpNix" = mkHome {
        hostname = "nvpNix";
        system = "x86_64-linux";
      };
      "nvp@nvpWSL" = mkHome {
        hostname = "nvpWSL";
        system = "x86_64-linux";
      };
      "nvp@nvpMacMini" = mkHome {
        hostname = "nvpMacMini";
        system = "aarch64-darwin";
      };
      "nvp@nvp-vm" = mkHome {
        hostname = "nvp-vm";
        system = "aarch64-linux";
      };
    };
  };
}
