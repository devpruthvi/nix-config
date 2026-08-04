{
  config,
  lib,
  # Root of an out-of-repo "local overlay" dotfiles dir (e.g. a private work
  # repo's dotfiles-local/). Passed by the builders via extraSpecialArgs.
  localDotfilesDir ? null,
  ...
}: {
  # When a local overlay is provided, expose it once at ~/.config/nix-local as a
  # live (out-of-store) symlink. Individual program configs then look inside it
  # for their own subdir (e.g. nix-local/nvim, nix-local/wezterm) and load extra
  # files only if present — so per-program, per-file work config layers on top of
  # the shared base without editing any shared file. Absent -> nothing happens.
  xdg.configFile = lib.optionalAttrs (localDotfilesDir != null) {
    "nix-local".source = config.lib.file.mkOutOfStoreSymlink localDotfilesDir;
  };
}
