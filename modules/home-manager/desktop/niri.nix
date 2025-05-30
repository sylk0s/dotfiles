{
  lib,
  sylib,
  config,
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
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    sylk.desktop = {
      apps.hyprlock.enable = true;
      services = {
        wpaperd.enable = true;
        hypridle.enable = true;
      };
    };

    programs.fuzzel.enable = true;
    services.swayosd.enable = true;

    programs.niri.settings = {
      prefer-no-csd = true;
    
      
      binds = let
        # Movement Key Sets (Left, Down, Up, Right)
        one-handed = { left = "a"; down = "s"; up = "w"; right = "d"; };
        vim = { left = "h"; down = "j"; up = "k"; right = "l"; };
        arrows = { left = "Left"; down = "Down"; up = "Up"; right = "Right"; };

        # Key sets for all, left/right, up/down 
        keysets = [one-handed vim arrows];
        lr-keysets = map (ks: filterAttrs (n: v: n == "left" || n == "right") ks) keysets;
        ud-keysets = map (ks: filterAttrs (n: v: n == "up" || n == "down") ks) keysets;

        # generates a bind for all keys, for all duplicate keysets
        map-binds = sets: opt-f: key-f: combine-attrs (map (set: concatMapAttrs (dir: key: { "${key-f key}".action = config.lib.niri.actions.${(opt-f dir)}; }) set) sets);

        # specified keyset maps
        map-dirs = map-binds keysets;
        map-lr = map-binds lr-keysets;
        map-ud = map-binds ud-keysets;
      in with config.lib.niri.actions; {
# Quit
        "Mod+Escape".action = quit;
# Suspend
# Spawns,,,
        "Mod+R".action = spawn "fuzzel";
        "Mod+Tab".action = spawn "alacritty";
# lock
        "Mod+Alt+X".action = screenshot;
# screenshot
# close window
        "Mod+Q".action = close-window;
# fullscreen window (fake fullscreen?)
        "Mod+F".action = fullscreen-window;
# toggle tagged column
        "Mod+X".action = toggle-column-tabbed-display;
# centering(?)
# show hotkey overlay
        "Mod+Slash".action = show-hotkey-overlay;
# toggle floating windows
# toggle floating focus
# toggle overlay
        "Mod+E".action = toggle-overview;
# maximize column? expand colums to width?
        "Mod+C".action = maximize-column;
# swap windows
      }

# focus column
      // (map-lr (d: "focus-column-or-monitor-${d}") (k: "Mod+${k}"))
      // (map-ud (d: "focus-window-or-workspace-${d}") (k: "Mod+${k}"))

# move column
      // (map-lr (d: "move-column-${d}-or-to-monitor-${d}") (k: "Mod+Shift+${k}"))
      // (map-ud (d: "move-column-to-workspace-${d}") (k: "Mod+Shift+${k}"))

# move window
      // (map-lr (d: "consume-or-expel-window-${d}") (k: "Mod+Alt+${k}"))
      // (map-ud (d: "move-window-${d}-or-to-workspace-${d}") (k: "Mod+Alt+${k}"))

# adjust size
  # TODO Ctrl mod

# move workspaces between monitors?
# move windows between monitors?
      // {};
    };
  };
}
    
