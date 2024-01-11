{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.matlab;
in {
  options.modules.dev.matlab = {
    enable = mkBoolOpt false;
  };

  # must be impure
  config = mkIf cfg.enable {
    nixpkgs.overlays = let
      nix-matlab = import (builtins.fetchTarball {
        url = "https://gitlab.com/doronbehar/nix-matlab/-/archive/master/nix-matlab-master.tar.gz";
        sha256 = "0iyqwsb3wb6clv6l561kpsv5vinng7vx1j871rb68khz0xmpdlb7";
      });
    in [
      nix-matlab.overlay
    ];
  };
}
