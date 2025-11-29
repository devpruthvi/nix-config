{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;
    enableReleaseChecks = false;
    autoEnable = false;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-simple-dark-gray.png";
      sha256 = "sha256-JaLHdBxwrphKVherDVe5fgh+3zqUtpcwuNbjwrBlAok=";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";

    fonts = {
      monospace = {
        package = (pkgs.stdenv.mkDerivation {
          pname = "iosvmata";
          version = "1.2.0";

          src = pkgs.fetchurl {
            url = "https://github.com/N-R-K/Iosvmata/releases/download/v1.2.0/Iosvmata-v1.2.0.tar.zst";
            sha256 = "0bhjnjfkllr8xb89dpvwrgp9cf8w8jx7l1myqp3w9rnwx73xpbqa";
          };

          nativeBuildInputs = [ pkgs.zstd ];

          unpackPhase = ''
            tar --zstd -xvf $src
          '';

          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
          '';
        });
        name = "Iosvmata";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };
}
