{
  pkgs,
  inputs,
  outputs,
  userConfig,
  ...
}: {
  # System-level darwin config only. home-manager is wired up centrally in
  # lib/builders.nix (mkDarwin), so it must not be configured here.
  imports = [
    ../../modules/darwin
    ../../modules/shared/nix.nix
    ../../modules/shared/packages.nix
  ];

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  system.primaryUser = userConfig.name;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
