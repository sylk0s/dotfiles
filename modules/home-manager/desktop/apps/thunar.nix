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
  cfg = config.sylk.desktop.apps.thunar;
in {
  options.sylk.desktop.apps.thunar = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunar
    ];

    # callback into callbacks/thunar.nix
  };
}
