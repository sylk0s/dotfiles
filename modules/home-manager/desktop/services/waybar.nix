# Dunst notification daemon configuration
{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sylk.desktop.services.waybar;
in {
  options.sylk.desktop.services.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf (cfg.enable) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 25;

          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["battery" "tray"];

          "battery" = {
            "tooltip-format" = "{time}";
          };
          "clock" = {
            "tooltip-format" = "{:%c}";
          };
        };
      };
    };
  };
}
