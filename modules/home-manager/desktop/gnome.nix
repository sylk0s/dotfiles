{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # callback to callbacks/gnome.nix
  };
}
