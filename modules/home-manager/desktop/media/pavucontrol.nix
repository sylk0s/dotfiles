{
  config,
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
    enable = mkBoolOpt true;
  };

  config = mkIf (cfg.enable && config.modules.audio.enable) {
    user.packages = with pkgs; [
      pavucontrol
    ];
  };
}
