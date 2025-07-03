{
    pkgs,
    ...
}: {
    home.packages = with pkgs; [ wezterm ];

    xdg.configFile."wezterm/weztermlua".source = ./wezterm.lua;
}