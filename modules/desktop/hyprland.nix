{
  options,
  config,
  lib,
  pkgs,
  hyprland,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
  configDir = config.dotfiles.configDir;

  # change this for nvidia
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
    nvidia = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
        greeters.enso.enable = true;
        background = "${config.dotfiles.configDir}/assets/wallpapers/hekatewhistler.jpeg";
        #wayland = true;
      };
      excludePackages = [pkgs.xterm];
    };

    # whats going on here? why are there both here...
    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = cfg.nvidia;
      xwayland.enable = true;
    };

    environment.sessionVariables = rec {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # other hyprland specific packages
    environment.systemPackages = with pkgs; [
      wofi
      slurp
      swww
      swaylock-effects
      hyprpicker
      wl-gammactl
      wl-clipboard
      wayshot
      swappy
      imagemagick
    ];

    security.pam.services.swaylock = {
      text = ''
        # PAM configuration file for the swaylock screen locker. By default, it includes
        # the 'login' configuration file (see /etc/pam.d/login)
        auth include login
      '';
    };

    home-manager.users.${config.user.name} = {
      # this lets you use the settings config
      #   imports = [
      #     inputs.hyprland.homeManagerModules.default
      #   ];

      wayland.windowManager.hyprland = {
        enable = true;
        enableNvidiaPatches = cfg.nvidia; #if you have nvidia
        xwayland.enable = true;
        package = hyprland;

        settings = {
          exec-once = [
            "ags"
          ];

          monitor = [
            "DP-1,1920x1080,1200x288,1"
            "HDMI-A-1,1920x1200,0x0,1,transform,3"
            ",preferred,auto,1"
          ];

          env = [
            "XCURSOR_SIZE,24"
          ];

          general = {
            gaps_in = 0;
            gaps_out = 0;
            border_size = 1;
            "col.active_border" = "rgba(E98FC8aa)";
            "col.inactive_border" = "rgba(595959aa)";
            layout = "dwindle";
          };

          decoration = {
            rounding = 0;
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
            new_is_master = true;
          };

          gestures = {
            workspace_swipe = false;
          };

          misc = {
            force_default_wallpaper = 0;
          };

          windowrulev2 = [
            "fakefullscreen, class:^(code-url-handler)$"
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
              (app "Z" "discord")
              (app "F" "firefox")
              (app "E" "thunar")
              (base "exec" "Tab" "${pkgs.alacritty}/bin/alacritty")

              # ags
              (ag "R" "applauncher")
              (ag "escape" "powermenu")
              (ag "E" "overview")
              (salt "exec" "Q" "ags quit; ags")

              # screenshot keybinds
              (sal "E" "wayshot --stdout -s \"$(slurp)\" | wl-copy")
              (sal "R" "wayshot -s \"$(slurp)\" -f ~/Pictures/Screenshots/sc-$(date +%s).jpg")
              (sal "F" "wayshot -f ~/Pictures/Screenshots/sc-$(date +%s).jpg")

              # misc TODO sort
              (sal "X" "${config.dotfiles.configDir}/eww/scripts/lock")

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
        # extraConfig = ''
        #       # hyprland config here
        #   ########################################################################################
        #   AUTOGENERATED HYPR CONFIG.
        #   PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
        #   OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
        #   ########################################################################################

        #   #
        #   # Please note not all available settings / options are set here.
        #   # For a full list, see the wiki
        #   #

        #   #autogenerated = 1 # remove this line to remove the warning

        #   # exec startup for the init script i stole
        #   # exec-once = ~/.config/eww/scripts/init
        #   #exec-once = ${config.dotfiles.configDir}/eww/scripts/${config.modules.desktop.services.eww.layout}
        #   exec-once = ags

        #   # See https://wiki.hyprland.org/Configuring/Monitors/
        #   # monitor = DP-1,1920x1080,0x288,1
        #   # monitor = HDMI-A-1,1920x1200,1920x0,1,transform,3
        #   monitor = DP-1,1920x1080,1200x288,1
        #   monitor = HDMI-A-1,1920x1200,0x0,1,transform,3
        #   # adds any random monitors automatically to the right of the other monitors
        #   monitor=,preferred,auto,1

        #   # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        #   # Execute your favorite apps at launch
        #   # exec-once = waybar & hyprpaper & firefox
        #   # preload = ${config.dotfiles.configDir}/assets/wallpapers/hekatewhistler.jpeg
        #   # wallpaper = monitor,contain:${config.dotfiles.configDir}/assets/wallpapers/hekatewhistler.jpeg
        #   # exec-once = ${config.dotfiles.configDir}/scripts/wallpaper.sh

        #   # Source a file (multi-file configs)
        #   # source = ~/.config/hypr/myColors.conf

        #   # Some default env vars.
        #   env = XCURSOR_SIZE,24

        #   # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        #   input {
        #       kb_layout = us
        #       kb_variant =
        #       kb_model =
        #       kb_options =
        #       kb_rules =

        #       follow_mouse = 1

        #       touchpad {
        #       natural_scroll = no
        #       }

        #       sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        #   }

        #   general {
        #       # See https://wiki.hyprland.org/Configuring/Variables/ for more

        #       gaps_in = 0
        #       gaps_out = 0
        #       border_size = 1
        #       col.active_border = rgba(E98FC8aa)
        #       col.inactive_border = rgba(595959aa)

        #       layout = dwindle
        #   }

        #   decoration {
        #       # See https://wiki.hyprland.org/Configuring/Variables/ for more

        #       rounding = 0
        #       blur {
        #               enabled = true # default
        #               size = 3 # smaller than default
        #               passes = 1 # default
        #               new_optimizations = true # default
        #           }
        #       #blur_size = 3
        #       #blur_passes = 1
        #       #blur_new_optimizations = on

        #       drop_shadow = yes
        #       shadow_range = 4
        #       shadow_render_power = 3
        #       col.shadow = rgba(1a1a1aee)
        #   }

        #   animations {
        #       enabled = yes

        #       # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        #       bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        #       # stupid bounce thing
        #       #animation = windows, 1, 7, myBezier
        #       animation = windowsOut, 1, 7, default, popin 80%
        #       animation = border, 1, 10, default
        #       animation = borderangle, 1, 8, default
        #       animation = fade, 1, 7, default
        #       animation = workspaces, 1, 6, default
        #   }

        #   dwindle {
        #       # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        #       pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        #       preserve_split = yes # you probably want this
        #   }

        #   master {
        #       # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        #       new_is_master = true
        #   }

        #   gestures {
        #       # See https://wiki.hyprland.org/Configuring/Variables/ for more
        #       workspace_swipe = off
        #   }

        #   misc {
        #           force_default_wallpaper = 0
        #   }

        #   # Example per-device config
        #   # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        #   device:epic-mouse-v1 {
        #       sensitivity = -0.5
        #   }
        #   # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #   # Example windowrule v1
        #   # windowrule = float, ^(kitty)$
        #   # Example windowrule v2
        #   # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        #   # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

        #   windowrulev2=fakefullscreen, class:^(code-url-handler)$

        #   # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        #   $mainMod = SUPER

        #   # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        #   bind = $mainMod, Q, killactive
        #   bind = $mainMod SHIFT, Z, exec, discord
        #   bind = $mainMod, escape, exec, ags -t powermenu
        #   bind = $mainMod SHIFT, escape, exit,
        #   bind = $mainMod, E, exec, dolphin
        #   bind = $mainMod, V, togglefloating,
        #   #bind = $mainMod, R, exec, wofi --show drun
        #   bind = $mainMod, P, pseudo, # dwindle
        #   bind = $mainMod, U, togglesplit, # dwindle
        #   bind = $mainMod SHIFT, F, exec, firefox
        #   bind = $mainMod, Tab, exec, ${pkgs.alacritty}/bin/alacritty
        #   bind = $mainMod ALT, X, exec, ${config.dotfiles.configDir}/eww/scripts/lock

        #   bind = $mainMod ALT, E, exec, wayshot --stdout -s "$(slurp)" | wl-copy
        #   bind = $mainMod ALT, S, exec, wayshot -s "$(slurp)" -f ~/Pictures/Screenshots/sc-$(date +%s).jpg
        #   bind = $mainMod ALT, D, exec, wayshot -f ~/Pictures/Screenshots/sc-$(date +%s).jpg

        #   bind = $mainMod, R, exec, ags -t applauncher
        #   bind = $mainMod SHIFT, R, exec, ags quit; ags
        #   bind = $mainMod ALT, w, exec, ags -t overview

        #   # Move focus with mainMod + arrow keys
        #   bind = $mainMod, h, movefocus, l
        #   bind = $mainMod, l, movefocus, r
        #   bind = $mainMod, k, movefocus, u
        #   bind = $mainMod, j, movefocus, d

        #   # Switch workspaces with mainMod + [0-9]
        #   bind = $mainMod, 1, workspace, 1
        #   bind = $mainMod, 2, workspace, 2
        #   bind = $mainMod, 3, workspace, 3
        #   bind = $mainMod, 4, workspace, 4
        #   bind = $mainMod, 5, workspace, 5
        #   bind = $mainMod, 6, workspace, 6
        #   bind = $mainMod, 7, workspace, 7
        #   bind = $mainMod, 8, workspace, 8
        #   bind = $mainMod, 9, workspace, 9
        #   bind = $mainMod, 0, workspace, 10

        #   # Move active window to a workspace with mainMod + SHIFT + [0-9]
        #   bind = $mainMod SHIFT, 1, movetoworkspace, 1
        #   bind = $mainMod SHIFT, 2, movetoworkspace, 2
        #   bind = $mainMod SHIFT, 3, movetoworkspace, 3
        #   bind = $mainMod SHIFT, 4, movetoworkspace, 4
        #   bind = $mainMod SHIFT, 5, movetoworkspace, 5
        #   bind = $mainMod SHIFT, 6, movetoworkspace, 6
        #   bind = $mainMod SHIFT, 7, movetoworkspace, 7
        #   bind = $mainMod SHIFT, 8, movetoworkspace, 8
        #   bind = $mainMod SHIFT, 9, movetoworkspace, 9
        #   bind = $mainMod SHIFT, 0, movetoworkspace, 10

        #   # Scroll through existing workspaces with mainMod + scroll
        #   bind = $mainMod, mouse_down, workspace, e+1
        #   bind = $mainMod, mouse_up, workspace, e-1

        #   # Move/resize windows with mainMod + LMB/RMB and dragging
        #   bindm = $mainMod, mouse:272, movewindow
        #   bindm = $mainMod, mouse:273, resizewindow
        # '';
      };
    };
  };
}
