{
  stdenv,
  fetchurl,
  zstd,
}:
stdenv.mkDerivation {
  pname = "iosvmata";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/N-R-K/Iosvmata/releases/download/v1.2.0/Iosvmata-v1.2.0.tar.zst";
    sha256 = "0bhjnjfkllr8xb89dpvwrgp9cf8w8jx7l1myqp3w9rnwx73xpbqa";
  };

  nativeBuildInputs = [zstd];

  unpackPhase = "tar --zstd -xvf $src";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
  '';
}
