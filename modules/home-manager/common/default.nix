{
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ../programs/brave
    ../programs/vscode
    ../programs/zsh
    ../programs/neovim
    ../programs/btop
    ../programs/bat
    ../programs/fzf
    ../programs/tmux
    ../programs/git
    ../programs/lazygit
    ../programs/wezterm
    ../programs/starship
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

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

  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
