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
    home.packages = with pkgs; [networkmanagerapplet];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 20;

          # TODO make this not hardcoded? base it off of the desktop enabled,,,
          # niri/workspaces vs hyprland/workspaces
          modules-left = [];
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
