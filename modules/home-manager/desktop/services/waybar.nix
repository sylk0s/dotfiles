# Dunst notification daemon configuration
{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.services.waybar;
in {
  options.modules.desktop.services.waybar = {
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
          height = 30;

          modules-center = ["clock" "battery" "network" "wlr/taskbar" "hyprland/workspaces" "tray"];

          "battery" = {
            "tooltip-format" = "{time}";
          };
          "clock" = {
            "tooltip-format" = "{:%c}";
          };
          "network" = {
            "format-wifi" = "{icon}";
            "format-icons" = ["󰤟" "󰤢" "󰤥" "󰤨"];
            "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
          };
        };
      };
    };
  };
}
