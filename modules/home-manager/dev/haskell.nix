{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.modules.dev.haskell;
in {
  options.modules.dev.haskell = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (haskellPackages.ghcWithPackages (pkgs: with pkgs; [cabal-install]))
    ];
  };
}
