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

  cfg = config.sylk.desktop.hyprland;

  # change this for nvidia
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
  imports = [inputs.hyprland.homeManagerModules.default];

  # callback for hyprland system support

  options.sylk.desktop.hyprland = {
    enable = mk-enable false;
    nvidia = mk-bool-opt false;
  };

  config = let
    # Generates the monitor string used to enable a monitor
    # Used by both initial monitor setting, and by the lid switch
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
      sylk.desktop = {
        services = {
          wpaperd.enable = true;
          hypridle.enable = true;
        };

        apps = {
          hyprlock.enable = true;
        };
      };

      home = {
        # other hyprland specific packages
        packages = with pkgs; [
          slurp
          swww
          hyprpicker
          wl-gammactl
          wl-clipboard
          grim
          swappy
          imagemagick
          kdePackages.xwaylandvideobridge
          libnotify
          brightnessctl
        ];
      };

      programs.fuzzel.enable = true;
      services.swayosd.enable = true;

      # this is the hm module
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = hyprland;

        # needed for UWSM
        systemd.enable = false;

        settings = {
          exec-once = [
            "uwsm app -- nm-applet"
            "uwsm app -- blueman-applet"
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

          # smart gaps
          workspace = [
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"
          ];

          windowrulev2 = [
            "bordersize 0, floating:0, onworkspace:w[tv1]"
            "rounding 0, floating:0, onworkspace:w[tv1]"
            "bordersize 0, floating:0, onworkspace:f[1]"
            "rounding 0, floating:0, onworkspace:f[1]"
          ];

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
              (app "Z" "uwsm app -- vesktop")
              (app "F" "uwsm app -- firefox")
              (app "E" "uwsm app -- thunar")
              (app "X" "uwsm app -- signal-desktop")
              (app "C" "uwsm app -- spotify")
              (app "R" "uwsm app -- code")
              (base "exec" "Tab" "uwsm app -- ${pkgs.alacritty}/bin/alacritty")
              (base "exec" "R" "uwsm app -- fuzzel")

              # screenshot keybinds
              (sal "E" "uwsm app -- ${inputs.self.outPath}/config/scripts/screenshot.sh sel-clip")
              (sal "R" "uwsm app -- ${inputs.self.outPath}/config/scripts/screenshot.sh sel-file")
              (sal "F" "uwsm app -- ${inputs.self.outPath}/config/scripts/screenshot.sh full-file")

              (sal "X" "uwsm app -- hyprlock")

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

              # brightness
              ",XF86MonBrightnessUp, exec, uwsm app -- swayosd-client --brightness raise"
              ",XF86MonBrightnessDown, exec, uwsm app -- swayosd-client --brightness lower"

              # audio
              ",XF86AudioRaiseVolume, exec, uwsm app -- swayosd-client --output-volume raise"
              ",XF86AudioLowerVolume, exec, uwsm app -- swayosd-client --output-volume lower"
              ",XF86AudioMute, exec, uwsm app -- swayosd-client --output-volume mute-toggle"

              # caps lock thing
              ",Caps_Lock, exec, uwsm app -- swayosd-client --caps-lock"

              "SUPER,b,sendshortcut,,mouse:272"
            ]
            # ++ (map (i: (map (j: swpfocus (toString j) (toString i [0]))) i [1]) dirs)
            # ++ (map (i: (map (j: mvfocus (toString j) (toString i [0]))) i [1]) dirs)
            ++ (map (i: ws (toString i) (toString i)) wsarr)
            ++ (map (i: mvtows (toString i) (toString i)) wsarr);

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
        };
      };
    };
}
