{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    # Ensure aerospace package installed
    programs.aerospace = {
      enable = true;

      settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);

      # Launch on startup
      launchd.enable = true;
    };
  };
}
