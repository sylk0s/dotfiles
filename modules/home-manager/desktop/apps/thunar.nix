{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.apps.thunar;
in {
  options.modules.desktop.apps.thunar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
    ];

    # callback into callbacks/thunar.nix
  };
}
