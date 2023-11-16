{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.pavucontrol;
in {
  options.modules.desktop.media.pavucontrol = {
    enable = mkBoolOpt true;
  };

  config = mkIf (cfg.enable && config.modules.hardware.audio.enable) {
    user.packages = with pkgs; [
      pavucontrol
    ];
  };
}
