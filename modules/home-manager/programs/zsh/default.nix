{
    lib,
    pkgs,
    ...
}: {
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
        };
    };
}