{pkgs, ...}: let
  ghostty =
    if pkgs.stdenv.isDarwin
    then pkgs.ghostty-bin
    else pkgs.ghostty;
  editor = "${ghostty}/bin/ghostty";
in {
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?q={}";
      gh = "https://github.com/search?q={}&type=repositories";
      np = "https://search.nixos.org/packages?channel=unstable&query={}";
      no = "https://search.nixos.org/options?channel=unstable&query={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      hm = "https://home-manager-options.extranix.com/?query={}";
      aw = "https://wiki.archlinux.org/?search={}";
      yt = "https://www.youtube.com/results?search_query={}";
    };

    settings = {
      auto_save.session = true;
      confirm_quit = ["downloads"];
      changelog_after_upgrade = "minor";

      scrolling.smooth = true;

      tabs = {
        show = "multiple";
        position = "top";
        last_close = "close";
        title.format = "{audio}{index}: {current_title}";
      };

      downloads = {
        location.directory = "~/Downloads";
        location.prompt = false;
        remove_finished = 10000;
      };

      content = {
        pdfjs = true;
        autoplay = false;
        blocking.enabled = true;
        blocking.method = "both";
        javascript.clipboard = "access";
        notifications.enabled = "ask";
      };

      editor.command = [editor "-e" "nvim" "-c" "normal {line}G{column0}l" "{file}"];

      url.default_page = "about:blank";
      url.start_pages = ["about:blank"];
    };

    keyBindings.normal = {
      "gJ" = "tab-move +";
      "gK" = "tab-move -";

      ",m" = "spawn mpv {url}";
      ",M" = "hint links spawn mpv {hint-url}";
      ",d" = "config-cycle colors.webpage.darkmode.enabled true false";
      ",s" = "config-cycle statusbar.show always never";
      ",z" = "config-cycle tabs.show always never";

      ",c" = "config-edit";
      ",r" = "config-source ;; message-info 'qutebrowser config reloaded'";
    };
  };

  home.packages = [pkgs.mpv];

  # Colors and fonts come from the shared base16 scheme.
  stylix.targets.qutebrowser.enable = true;
}
