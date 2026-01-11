{
  lib,
  sylib,
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.services.hypridle;
in {
  options.sylk.desktop.services.hypridle = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 150; # 2.5m
            on-timeout = "${pkgs.libnotify}/bin/notify-send -a \"Idle\" \"Dimming screen\""; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          }
          {
            timeout = 150; # 2.5m
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 1"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r"; # monitor backlight restore.
          }
          {
            timeout = 290; # 2m 50s
            on-timeout = "${pkgs.libnotify}/bin/notify-send -a \"Idle\" \"Locking screen in 10s\"";
          }
          {
            timeout = 300; # 5m
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            # TODO: abstract this per wm
            timeout = 360; # 6m
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 600; # 10 mins
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
