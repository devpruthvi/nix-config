{
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    homebrew = {
      enable = true;
      casks = [
        "pearcleaner"
      ];
    };
  };
}
