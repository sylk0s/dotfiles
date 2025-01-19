{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.desktop.media.pavucontrol;
in {
  options.sylk.desktop.media.pavucontrol = {
    enable = mk-enable config.sylk.desktop.enable;
  };

  config = mkIf (cfg.enable && osConfig.sylk.system.audio.enable) {
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
