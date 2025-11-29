{
  pkgs,
  inputs,
  outputs,
  userConfig,
  darwinModules,
  ...
}: {
  imports = [
    "${darwinModules}"
    ../../modules/shared/nix.nix
    ../../modules/shared/packages.nix
    ../../modules/shared/nix.nix
    ../../modules/shared/packages.nix
  ];

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${userConfig.name} = {
      imports = [
        ../../home/${userConfig.name}/nvpMacMini/default.nix
        inputs.mac-app-util.homeManagerModules.default
      ];
    };
    extraSpecialArgs = {
      inherit inputs outputs userConfig;
      hmModules = "${inputs.self}/modules/home-manager";
      dotfilesDir = "/Users/${userConfig.name}/nix-config/dotfiles";
    };
  };

  system.primaryUser = userConfig.name;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
