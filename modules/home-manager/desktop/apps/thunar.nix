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
  cfg = config.modules.desktop.apps.thunar;
in {
  options.modules.desktop.apps.thunar = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      xfce.thunar
    ];

    # callback into callbacks/thunar.nix
  };
}
