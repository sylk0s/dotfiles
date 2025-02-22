{
  config,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.services.hyprpanel;
in {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  options.sylk.desktop.services.hyprpanel = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;
      theme = "catppuccin_mocha";
      # this is needed because otherwise I *can't* use my password for this
      # TODO revisit locking stuff
      # security.pam.services.swaylock = {};

      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        "bar.layouts" = {
          "0" = {
            left = ["dashboard" "workspaces" "windowtitle"];
            middle = ["clock"];
            # media, notifications
            right = ["hypridle" "media" "volume" "battery" "systray" "power"];
          };
        };
      };

      settings = {
        bar.launcher.autoDetectIcon = true;
        bar.workspaces.show_icons = true;
        bar.clock.format = "%a %b %d  %H:%M:%S %p";

        menus.clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.unit = "metric";
        };
        menus.dashboard.powermenu.avatar.image = "${inputs.self.outPath}/config/assets/julia.png";
        menus.dashboard.powermenu.avatar.name = "${config.home.username}";

        menus.dashboard.directories.enabled = false;
        menus.dashboard.stats.enable_gpu = true;

        theme = {
          bar = {
            transparent = false;
            outer_spacing = "8px";
            margin_sides = "0em";
            margin_top = "0em";
            buttons = {
              padding_x = "0.5rem";
              padding_y = "0rem";
            };
          };

          font = {
            size = "13px";
          };
        };
      };
    };
  };
}
