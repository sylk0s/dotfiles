{ pkgs, }:
pkgs.stdenvNoCC.mkDerivation {
    pname = "julia-mono-nerd-font";
    version = "0.060";

    src = pkgs.fetchurl {
      url = "https://github.com/mietzen/juliamono-nerd-font/releases/download/v0.060/fonts.zip";
      hash = "sha256-1vtyY1rkb66I5xS7GZUOgMrvjHlP6/YYZ9DD7a1A+oc=";
    };

    unpackPhase = ''
      runHook preUnpack
      ${pkgs.unzip}/bin/unzip $src

      runHook postUnpack 
    '';

    installPhase = ''
      runHook preInstall

      install -Dm644 *.ttf -t $out/share/fonts/truetype

      runHook postInstall
    '';
}
