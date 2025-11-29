{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}:
with lib; let
  luaposix = pkgs.lua5_4.pkgs.buildLuarocksPackage {
    pname = "luaposix";
    version = "36.3-1";
    knownRockspec =
      (pkgs.fetchurl {
        url = "mirror://luarocks/luaposix-36.3-1.rockspec";
        sha256 = "0jwah6b1bxzck29zxbg479zm1sqmg7vafh7rrkfpibdbwnq01yzb";
      }).outPath;
    src = pkgs.fetchzip {
      url = "http://github.com/luaposix/luaposix/archive/v36.3.zip";
      sha256 = "0k05mpscsqx1yd5vy126brzc35xk55nck0g7m91vrbvvq3bcg824";
    };
  };
  # Due to a bug in 5.4.7, we need to use 5.4.4 for sketchybar
  lua5_4_4 = pkgs.lua5_4.withPackages (ps: [
    ps.lua-cjson
    luaposix
  ]);
in {
  config = lib.mkIf (pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [
      sketchybar-app-font
      switchaudio-osx
      # nowplaying-cli
    ];

    xdg.configFile = {
      "sketchybar" = {
        # relative path is needed here (instead of absolute path with ${dotfilesDir})
        source = ../../../../dotfiles/.config/sketchybar;
        recursive = true;
        onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
      };
    };

    xdg.configFile."sketchybar/sketchybarrc" = {
      text = ''
        #!${lua5_4_4}/bin/lua

        -- Add the sketchybar module to the package cpath (the module could be
        -- installed into the default search path then this would not be needed)
        package.cpath = package.cpath .. ";${pkgs.sbar-lua}/lib/sketchybar.so"
        package.path = package.path .. ";${dotfilesDir}/sketchybar/?.lua;${dotfilesDir}/sketchybar/?/init.lua"

        sbmenus = "${pkgs.sbmenus}/bin/sbmenus"

        require("helpers")
        require("init")
      '';
      executable = true;
    };

    xdg.configFile."sketchybar/colors.lua" = {
      text = ''
        return {
          bg1 = 0xff${config.lib.stylix.colors.base00},
          bg2 = 0xff${config.lib.stylix.colors.base01},
          fg1 = 0xff${config.lib.stylix.colors.base05},
          fg2 = 0xff${config.lib.stylix.colors.base04},
          accent = 0xff${config.lib.stylix.colors.base0D},
          red = 0xff${config.lib.stylix.colors.base08},
          green = 0xff${config.lib.stylix.colors.base0B},
          yellow = 0xff${config.lib.stylix.colors.base0A},
          blue = 0xff${config.lib.stylix.colors.base0D},
          magenta = 0xff${config.lib.stylix.colors.base0E},
          cyan = 0xff${config.lib.stylix.colors.base0C},
          white = 0xff${config.lib.stylix.colors.base05},
          black = 0xff${config.lib.stylix.colors.base00},
          grey = 0xff${config.lib.stylix.colors.base03},
          transparent = 0x00000000,
          
          bar = {
            bg = 0xf0${config.lib.stylix.colors.base00}, -- 0xf0 alpha
            border = 0xff${config.lib.stylix.colors.base01},
          },
          popup = {
            bg = 0xe0${config.lib.stylix.colors.base00},
            border = 0xff${config.lib.stylix.colors.base01},
          },
        }
      '';
    };

    xdg.dataFile = {
      "sketchybar_lua/sketchybar.so" = {
        source = "${pkgs.sbar-lua}/lib/sketchybar.so";
        onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
      };
    };

    # xdg.configFile = {
    #   "aerospace" = {
    #     source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/aerospace";
    #     recursive = true;
    #   };
    # };
  };
}
