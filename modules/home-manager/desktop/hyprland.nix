{
  osConfig,
  config,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf map toString;
  inherit (sylib) mk-enable mk-bool-opt;

  cfg = config.modules.desktop.hyprland;
  configDir = osConfig.dotfiles.configDir;

  # change this for nvidia
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
  imports = [inputs.hyprland.homeManagerModules.default];

  # callback for hyprland system support

  options.modules.desktop.hyprland = {
    enable = mk-enable false;
    nvidia = mk-bool-opt false;
  };

  config = mkIf cfg.enable {
    home = {
      # other hyprland specific packages
      packages = with pkgs; [
        wofi
        slurp
        swww
        # swaylock-effects
        hyprpicker
        wl-gammactl
        wl-clipboard
        grim
        swappy
        imagemagick
        xwaylandvideobridge
        libnotify
      ];
    };

    programs.swaylock.enable = true;

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
          "ags"
          "${configDir}/scripts/wallpaper.sh"
          "nm-applet"
          "blueman-applet"
        ];

        monitor = [
          "DP-1,1920x1080,1200x288,1"
          "HDMI-A-1,1920x1200,0x0,1,transform,3"
          "DP-7,preferred,auto-left,1"
          ",preferred,auto,1"
        ];

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
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
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

            # ags
            (ag "R" "applauncher")
            (ag "escape" "powermenu")
            (ag "E" "overview")
            (salt "exec" "Q" "ags quit; ags")

            # screenshot keybinds
            (sal "E" "${configDir}/scripts/screenshot.sh sel-clip")
            (sal "R" "${configDir}/scripts/screenshot.sh sel-file")
            (sal "F" "${configDir}/scripts/screenshot.sh full-file")

            (sal "X" "${configDir}/eww/scripts/lock")

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
