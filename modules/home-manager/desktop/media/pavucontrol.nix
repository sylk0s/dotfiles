{
  config,
  osConfig,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.media.pavucontrol;
in {
  options.modules.desktop.media.pavucontrol = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable && osConfig.modules.audio.enable) {
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
