{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.dev.arduino;
in {
  options.modules.dev.arduino = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arduino-ide
      arduino-cli
      screen
    ];
  };
}
