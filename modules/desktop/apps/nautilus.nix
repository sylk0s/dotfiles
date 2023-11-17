{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.nautilus;
in {
  options.modules.desktop.apps.nautilus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gnome.nautilus
    ];

    environment.sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    # services.tumbler.enable = true;
    services.gvfs.enable = true;
  };
}
