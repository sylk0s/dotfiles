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
  cfg = config.modules.desktop.media.pavucontrol;
in {
  options.modules.desktop.media.pavucontrol = {
    enable = mk-enable config.modules.desktop.enable;
  };

  config = mkIf (cfg.enable && osConfig.modules.audio.enable) {
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
