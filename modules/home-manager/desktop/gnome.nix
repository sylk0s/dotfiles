{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-bool-opt;
  cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = mk-bool-opt false;
  };

  config = mkIf cfg.enable {
    # callback to callbacks/gnome.nix
  };
}
