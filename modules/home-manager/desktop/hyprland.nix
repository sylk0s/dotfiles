{
  osConfig,
  config,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkIf map filter concatLists;
  inherit (sylib) mk-enable mk-bool-opt;

  cfg = config.modules.desktop.hyprland;

  # change this for nvidia
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
  imports = [inputs.hyprland.homeManagerModules.default];

  # callback for hyprland system support

  options.modules.desktop.hyprland = {
    enable = mk-enable false;
    nvidia = mk-bool-opt false;
  };

  config = let
    monitor-str = (
      m:
        "${builtins.toString m.name},"
        + (
          if m.width != 0 && m.height != 0
          then
            (
              "${builtins.toString m.width}x${builtins.toString m.height}"
              + (
                if m.refresh-rate
                then "@${builtins.toString m.refresh-rate}"
                else ""
              )
            )
          else "preferred,"
        )
        + (
          if m.x-off != 0 && m.y-off != 0
          then "${builtins.toString m.x-off}x${builtins.toString m.y-off}"
          else "auto-down,"
        )
        + "${builtins.toString m.scale}"
        + (
          if m.transform == 0
          then ""
          else "transform,${builtins.toString m.transform}"
        )
        + (
          if m.mirror != ""
          then "mirror,${builtins.toString m.mirror}"
          else ""
        )
    );
  in
    mkIf cfg.enable {
      home = {
        # other hyprland specific packages
        packages = with pkgs; [
          wofi
          slurp
          swww
          hyprpicker
          wl-gammactl
          wl-clipboard
          grim
          swappy
          imagemagick
          xwaylandvideobridge
          libnotify
          brightnessctl
          networkmanagerapplet
        ];
      };

      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;
          preload = [
            "${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-far-from-tomorrow-1080px.jpg"
            "${inputs.self.outPath}/config/assets/wallpapers/nix-black-4k.png"
          ];

          # TODO add wallpapers to this
          wallpaper = [
            "eDP-1, ${inputs.self.outPath}/config/assets/wallpapers/alena-aenami-far-from-tomorrow-1080px.jpg"
            ", ${inputs.self.outPath}/config/assets/wallpapers/nix-black-4k.png"
          ];
        };
      };

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
              timeout = 30; # 2.5min.
              on-timeout = "notify-send -a \"Idle 1\" dimming screen"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            }
            # {
            #   timeout = 60; # 2.5min.
            #   on-timeout = "brightnessctl -s set 1"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            #   on-resume = "brightnessctl -r"; # monitor backlight restore.
            # }
            # {
            #   timeout = 90; # 5min
            #   on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            # }
            {
              timeout = 45; # 5min.
              on-timeout = "notify-send -a \"Idle 2\" turning off screen"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            }
            # {
            #   timeout = 120; # 5.5min
            #   on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            #   on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            # }
            {
              timeout = 60; # 2.5min.
              on-timeout = "notify-send -a \"Idle 3\" locking session"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            }
            # {
            #   timeout = 150; # 10min
            #   on-timeout = "systemctl suspend"; # suspend pc
            # }
            {
              timeout = 90; # 2.5min.
              on-timeout = "notify-send -a \"Idle 4\" sleeping"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            }
          ];
        };
      };

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
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.2)";
            font_color = "$foreground";
            fade_on_empty = false;
            rounding = -1;
            check_color = "rgb(204, 136, 34)";
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
              color = "rgba(242, 243, 244, 0.75)";
              font_size = 22;
              font_family = "JetBrains Mono";
              position = "0, 300";
              halign = "center";
              valign = "center";
            }

            # TIME
            {
              monitor = "";
              text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
              color = "rgba(242, 243, 244, 0.75)";
              font_size = 95;
              font_family = "JetBrains Mono Extrabold";
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
              border_color = "$foreground";
              position = "0, -100";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };

      # this is the hm module
      wayland.windowManager.hyprland = {
        enable = true;
        #enableNvidiaPatches = cfg.nvidia; #if you have nvidia
        xwayland.enable = true;
        package = hyprland;

        # plugins = [
        #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        # ];

        settings = {
          exec-once = [
            "nm-applet"
            "blueman-applet"
          ];

          # constructs monitor config from my monitor options
          monitor =
            (map monitor-str (filter (m: m.enable) osConfig.sylk.system.monitors))
            ++ [",preferred,auto-up,1"];

          env = [
            "XCURSOR_SIZE,24"
          ];

          general = {
            gaps_in = 4;
            gaps_out = 8;
            border_size = 1;
            "col.active_border" = "rgba(E98FC8aa)";
            "col.inactive_border" = "rgba(595959aa)";
            layout = "dwindle";
          };

          decoration = {
            rounding = 12;
            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              new_optimizations = true;
            };
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
          };

          animations = {
            enabled = true;
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };

          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
            follow_mouse = true;
            touchpad = {
              natural_scroll = false;
            };
            sensitivity = 0;
          };

          master = {
            new_on_top = true;
          };

          gestures = {
            workspace_swipe = true;
          };

          misc = {
            force_default_wallpaper = 0;
          };

          # windowrulev2 = [
          #   "fakefullscreen, class:^(code-url-handler)$"
          # ];

          bind = let
            binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";

            base = binding "SUPER";
            sshf = binding "SUPER SHIFT";
            salt = binding "SUPER ALT";

            ws = base "workspace";
            swpfocus = base "movefocus";
            resize = base "resizeactive";
            mvact = binding "SUPER ALT" "moveactive";
            mvtows = binding "SUPER SHIFT" "movetoworkspace";
            ag = key: name: base "exec" "${key}" "ags -t ${name}";

            app = sshf "exec";
            sal = salt "exec";

            # workspaces that map directly to numbers, not 0/10
            wsarr = [1 2 3 4 5 6 7 8 9];

            # mappings for movement keys
            mu = ["w" "k" "up"];
            md = ["s" "j" "down"];
            ml = ["a" "h" "left"];
            mr = ["d" "l" "right"];

            # directions to map over
            dirs = [["u" mu] ["d" md] ["l" ml] ["r" mr]];
          in
            [
              # hyprland stuff
              (base "killactive" "Q" "")
              (base "togglefloating" "V" "")
              (base "fullscreen" "F" "")

              # apps
              (app "Z" "vesktop")
              (app "F" "firefox")
              (app "E" "thunar")
              (app "X" "signal-desktop")
              (app "C" "spotify")
              (app "R" "code")
              (base "exec" "Tab" "${pkgs.alacritty}/bin/alacritty")
              (base "exec" "R" "wofi --show run")

              # ags
              # (ag "R" "applauncher")
              (ag "escape" "powermenu")
              (ag "E" "overview")
              (salt "exec" "Q" "ags quit; ags")

              # screenshot keybinds
              (sal "E" "${inputs.self.outPath}/config/scripts/screenshot.sh sel-clip")
              (sal "R" "${inputs.self.outPath}/config/scripts/screenshot.sh sel-file")
              (sal "F" "${inputs.self.outPath}/config/scripts/screenshot.sh full-file")

              (sal "X" "hyprlock")

              # movement

              (swpfocus "h" "l")
              (swpfocus "l" "r")
              (swpfocus "k" "u")
              (swpfocus "j" "d")

              # workspace 10 is 0
              (ws "0" "10")
              (mvtows "0" "10")

              (base "workspace" "mouse_down" "e+1")
              (base "workspace" "mouse_up" "e-1")
              # "SUPER, grave, hyprexpo:expo, toggle"
            ]
            # ++ (map (i: (map (j: swpfocus (toString j) (toString i [0]))) i [1]) dirs)
            # ++ (map (i: (map (j: mvfocus (toString j) (toString i [0]))) i [1]) dirs)
            ++ (map (i: ws (toString i) (toString i)) wsarr)
            ++ (map (i: mvtows (toString i) (toString i)) wsarr);

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];

          bindl = concatLists (map (m: [
            # trigger when the switch is turning on
            ", switch:on:${m.switch}, exec, hyprctl keyword monitor \"${m.name}, disable\""
            # trigger when the switch is turning off
            ", switch:off:${m.switch}, exec, hyprctl keyword monitor \"${monitor-str m}\""
          ]) (filter (m: m.switch != "") osConfig.sylk.system.monitors));

          # plugin = {
          #   hyperexpo = {
          #     columns = 3;
          #     gap_size = 5;
          #     bg_col = "rgba(111111)";
          #     workspace_method = "static 1";

          #     enable_gesture = true;
          #     gesture_distance = 300;
          #     gesture_positive = true;
          #   };
          # };
        };
      };
    };
}
