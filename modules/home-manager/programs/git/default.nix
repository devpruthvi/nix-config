{
  pkgs,
  userConfig,
  ...
}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      user.name = userConfig.fullName;
      user.email = userConfig.email;
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
