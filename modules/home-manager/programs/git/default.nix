{
  pkgs,
  lib,
  userConfig,
  ...
}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      # mkDefault so a wrapping (e.g. work) home module can override the
      # identity — or add includeIf rules — without needing mkForce.
      user.name = lib.mkDefault userConfig.fullName;
      user.email = lib.mkDefault userConfig.email;
      pull.rebase = "true";
      credential.helper =
        if pkgs.stdenv.isDarwin
        then "osxkeychain"
        else "cache --timeout=300";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      keep-plus-minus-markers = true;
      light = false;
      line-numbers = true;
      navigate = true;
    };
  };

}
