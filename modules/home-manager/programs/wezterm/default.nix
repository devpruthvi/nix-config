{
    pkgs,
    ...
}: {
    home.packages = with pkgs; [ wezterm ];

    xdg.configFile."wezterm/wezterm.lua".source = ../../../../dotfiles/.config/wezterm/wezterm.lua;
}