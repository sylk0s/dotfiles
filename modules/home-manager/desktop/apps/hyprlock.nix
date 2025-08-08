{
  lib,
  sylib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.apps.hyprlock;
in {
  options.sylk.desktop.apps.hyprlock = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # so we can style it with our own config
    catppuccin.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;
      settings = {
        auth."pam:enabled" = true;

        # BACKGROUND
        background = {
          monitor = "";
          path = "${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-far-from-tomorrow-1080px.jpg";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        };

        # GENERAL
        general = {
          no_fade_in = true;
          no_fade_out = true;
          hide_cursor = false;
          grace = 0;
          disable_loading_bar = true;
        };

        # INPUT FIELD
        input-field = {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          # outer_color = "rgba(0, 0, 0, 0)";
          # inner_color = "rgba(0, 0, 0, 0.2)";
          # font_color = "rgb(245, 224, 220)";
          fade_on_empty = false;
          rounding = -1;
          # check_color = "rgb(204, 136, 34)";
          placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        };

        # DATE
        label = [
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
            # color = "rgb(245, 224, 220)";
            font_size = 22;
            # font_family = "JetBrains Mono";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }

          # TIME
          {
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
            # color = "rgb(245, 224, 220)";
            font_size = 95;
            # font_family = "JetBrains Mono Extrabold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];

        # Profile Picture
        image = [
          {
            monitor = "";
            path = "${inputs.self.outPath}/config/assets/julia.png";
            size = 100;
            border_size = 2;
            # border_color = "rgb(245, 224, 220)";
            position = "0, -100";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
