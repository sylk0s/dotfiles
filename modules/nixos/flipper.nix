{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.flipper;
in {
  options.modules.flipper = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.flipperzero.enable = true;
  };
}
