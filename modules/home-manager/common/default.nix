{
  inputs,
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ./local-overlay.nix

    # CLI core — installed on every machine. Everything else (GUI apps,
    # terminals, macOS desktop bits) is opt-in: import it per host, or use the
    # `bundles/desktop.nix` bundle. See modules/home-manager/programs/* and the
    # `homeManagerModules.<name>` flake outputs.
    ../programs/zsh
    ../programs/neovim
    ../programs/git
    ../programs/lazygit
    ../programs/tmux
    ../programs/fzf
    ../programs/bat
    ../programs/btop
    ../programs/starship
    ../programs/mise
    ../programs/personal-scripts

    # theming (applies to whatever apps a host does enable)
    ../../shared/stylix.nix
    inputs.stylix.homeModules.stylix
  ];


  # User's home env
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
  };

  home.packages = with pkgs;
    [
      wget
      tree
      eza
      fd
      jq
      ripgrep
      python3
      pipenv
    ]
    ++ lib.optionals stdenv.isDarwin [
      raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      pavucontrol
      unzip
    ];

  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

}
