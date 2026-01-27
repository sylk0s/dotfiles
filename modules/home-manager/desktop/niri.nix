{
  lib,
  sylib,
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf filterAttrs concatMapAttrs;
  inherit (sylib) mk-enable combine-attrs;

  cfg = config.sylk.desktop.niri;
in {
  options.sylk.desktop.niri = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    sylk.desktop = {
      apps.hyprlock.enable = true;
      services = {
        wpaperd.enable = true;
        hypridle.enable = true;
      };
    };

    # TODO should be done by niri flake
    services.gnome-keyring.enable = true;

    xdg.portal = {
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        # TODO should be done by niri flake
        xdg-desktop-portal-gnome
      ];

      config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };

      # TODO should be done by niri flake
      configPackages = config.programs.niri.package;
    };


    home.packages = with pkgs; [
      xwayland-satellite-unstable
      xdg-desktop-portal-gtk
      # for some reason this really hates me
      xdg-desktop-portal-gnome
    ];

    programs.fuzzel.enable = true;
    services.swayosd.enable = true;

    # programs.niri.enable = true;

    programs.niri.settings = {
      # gets rid of pesky bars for terminals
      prefer-no-csd = true;

      # disable while typing
      input.touchpad.dwt = true;

      hotkey-overlay.hide-not-bound = true;

      layout = {
        focus-ring = {
          width = 2;
        };

        tab-indicator = {
          hide-when-single-tab = true;
        };

        # empty-workspace-above-first = true;
        gaps = 6;
      };

      animations.slowdown = 0.5;

      # meow idk if i need this to get it to work automagically
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

      window-rules = [
        # highlights screencast window
        {
          matches = [{
            is-window-cast-target = true;
          }];

          focus-ring = {
            active.color = "#f38ba8";
            inactive.color = "#7d0d2d";
          };

          border = {
            inactive.color = "#7d0d2d";
          };

          shadow = {
            color = "#7d0d2d70";
          };

          tab-indicator = {
            active.color = "#f38ba8";
            inactive.color = "#7d0d2d";
          };
        }
      ];

      outputs = let
        generate_output = m: {
          name = m.name;
          value = {
            enable = m.enable;
            focus-at-startup = m.primary;
            mode = {
              height = m.height;
              width = m.width;
              # TODO this needs to be a float to work right
              # refresh = m.refresh-rate;
            };
            position = {
              x = m.x-off;
              y = m.y-off;
            };
            scale = m.scale;
            transform = {
              flipped = m.transform > 3;
              rotation = (lib.mod m.transform 4) * 90;
            };
          };
        };
      in lib.listToAttrs (map generate_output osConfig.sylk.system.monitors);

      /* recent-windows = {
        binds = {
          "Alt+Tab" = {
            action = next-window;
            hotkey-overlay.title = "Next window";
          };

          "Alt+Shift+Tab" = { 
            action = previous-window; 
          };
          "Alt+grave" = { 
            action = next-window; 
            filter="app-id"; 
          };
          "Alt+Shift+grave" = { 
            action = previous-window;
            filter="app-id"; 
          };
        }
      }; */

      binds = let
        # Movement Key Sets (Left, Down, Up, Right)
        one-handed = {
          left = "a";
          down = "s";
          up = "w";
          right = "d";
        };
        vim = {
          left = "h";
          down = "j";
          up = "k";
          right = "l";
        };
        arrows = {
          left = "Left";
          down = "Down";
          up = "Up";
          right = "Right";
        };

        # Key sets for all, left/right, up/down
        keysets = [one-handed vim arrows];
        lr-keysets = map (ks: filterAttrs (n: v: n == "left" || n == "right") ks) keysets;
        ud-keysets = map (ks: filterAttrs (n: v: n == "up" || n == "down") ks) keysets;

        # generates a bind for all keys, for all duplicate keysets
        map-binds = sets: opt-f: key-f: format-f: {arg-application ? x: _dir: x}:
          combine-attrs (map (set:
            concatMapAttrs (
              dir: key: {
                "${key-f key}" = {
                  action = arg-application config.lib.niri.actions.${(opt-f dir)} dir;
                  hotkey-overlay.title = format-f dir;
                };
              }
            )
            set)
          sets);

        # specified keyset maps
        map-dirs = map-binds keysets;
        map-lr = map-binds lr-keysets;
        map-ud = map-binds ud-keysets;
      in
        with config.lib.niri.actions;
          {
            # Unbind hotkey-overlay results
            # "".hotkey-overlay.hidden = true;

            # Quit
            "Mod+Escape" = {
              action = quit;
              hotkey-overlay.title = "Quit niri";
            };
            # Spawns,,,
            "Mod+R" = {
              action = spawn "fuzzel";
              hotkey-overlay.title = "Spawn `fuzzel`";
            };
            "Mod+Tab" = {
              action = spawn "alacritty";
              hotkey-overlay.title = "Spawn `alacritty`";
            };
            # lock
            "Mod+Alt+X" = {
              action = spawn "hyprlock";
              hotkey-overlay.title = "Lock the screen";
            };
            # screenshot
            "Mod+Alt+E" = {
              action.screenshot = [];
              hotkey-overlay.title = "Screenshot";
            };
            # close window
            "Mod+Q" = {
              action = close-window;
              hotkey-overlay.title = "Close focused window";
            };
            # fullscreen window (fake fullscreen?)
            "Mod+F" = {
              action = fullscreen-window;
              hotkey-overlay.title = "Fullscreen window";
            };
            # toggle tagged column
            "Mod+Z" = {
              action = toggle-column-tabbed-display;
              hotkey-overlay.title = "Toggle tagged/column mode";
            };
            # show hotkey overlay
            "Mod+Slash" = {
              action = show-hotkey-overlay;
              hotkey-overlay.title = "Show this overlay";
            };
            # toggle overlay
            "Mod+E" = {
              action = toggle-overview;
              hotkey-overlay.title = "Toggle overview";
            };
            # maximize column? expand colums to width?
            "Mod+C" = {
              action = maximize-column;
              hotkey-overlay.title = "Maximize focused column";
            };
            # audio
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action = spawn "swayosd-client" "--output-volume" "raise";
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action = spawn "swayosd-client" "--output-volume" "lower";
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action = spawn "swayosd-client" "--output-volume" "mute-toggle";
            };
            # brightness
            "XF86MonBrightnessUp" = {
              action = spawn "swayosd-client" "--brightness" "raise";
            };
            "XF86MonBrightnessDown" = {
              action = spawn "swayosd-client" "--brightness" "lower";
            };
            # caps
            "Caps_Lock" = {
              action = spawn "swayosd-client" "--caps-lock";
            };
            # Mouse gestures
            # toggle floating windows
            # toggle floating focus
            # swap windows
            # centering(?)
            # Suspend
          }
          # focus column
          // (map-lr (d: "focus-column-or-monitor-${d}") (k: "Mod+${k}") (d: "Focus column ${d}") {})
          // (map-ud (d: "focus-window-or-workspace-${d}") (k: "Mod+${k}") (d: "Focus column ${d}") {})
          # move column
          // (map-lr (d: "move-column-${d}-or-to-monitor-${d}") (k: "Mod+Shift+${k}") (d: "Move column ${d}") {})
          // (map-ud (d: "move-column-to-workspace-${d}") (k: "Mod+Shift+${k}") (d: "Move column ${d}") {})
          # move window
          // (map-lr (d: "consume-or-expel-window-${d}") (k: "Mod+Alt+${k}") (d: "Move window ${d}") {})
          // (map-ud (d: "move-window-${d}-or-to-workspace-${d}") (k: "Mod+Alt+${k}") (d: "Move window ${d}") {})
          # adjust size
          // (map-lr (_d: "set-column-width") (k: "Mod+Ctrl+${k}")
            (d:
              if d == "left"
              then "Shrink column width"
              else "Expand column width")
            {
              arg-application = action: d:
                if d == "left"
                then action "-10%"
                else action "+10%";
            })
          # move workspaces between monitors?
          # move windows between monitors?
          // {};
    };
  };
}
