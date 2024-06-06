{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.apps.nautilus;
in {
  options.modules.desktop.apps.nautilus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gnome.nautilus
    ];

    env = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    # services.tumbler.enable = true;
    services.gvfs.enable = true;
  };
}
