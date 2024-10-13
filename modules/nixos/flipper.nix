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

  cfg = config.modules.flipper;
in {
  options.modules.flipper = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    hardware.flipperzero.enable = true;
  };
}
