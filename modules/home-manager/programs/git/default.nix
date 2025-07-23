{
  pkgs,
  userConfig,
  ...
}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = userConfig.fullName;
    userEmail = userConfig.email;
    delta = {
      enable = true;
      options = {
        keep-plus-minus-markers = true;
        light = false;
        line-numbers = true;
        navigate = true;
      };
    };
    extraConfig = {
      pull.rebase = "true";
      credential.helper =
        if pkgs.stdenv.isDarwin
        then "osxkeychain"
        else "cache --timeout=300";
    };
  };

  # Enable catppuccin theming for git delta
  catppuccin.delta.enable = true;
}
