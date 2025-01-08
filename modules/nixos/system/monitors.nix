# Inspired by Misterio77: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf mkOption types length any concatLists filter;

  cfg = config.sylk.system.monitors;
in {
  options.sylk.system.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
            description = "The name of this monitor";
          };
          primary = mkOption {
            type = types.bool;
            default = false;
            description = "Flags this monitor as the primary, may only be set once";
          };
          width = mkOption {
            type = types.int;
            example = 1920;
            default = 0;
            description = "Width of this monitor";
          };
          height = mkOption {
            type = types.int;
            example = 1080;
            default = 0;
            description = "Height of this monitor";
          };
          refresh-rate = mkOption {
            type = types.int;
            default = 0;
            description = "Refresh rate of this monitor, if unset (0), defaults to highest";
          };
          x-off = mkOption {
            type = types.int;
            default = 0;
            description = "Offset in X, positive is right";
          };
          y-off = mkOption {
            type = types.int;
            default = 0;
            description = "Offset in Y, positive is down";
          };
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Enable this monitor";
          };
          transform = mkOption {
            type = types.ints.between 0 7;
            default = 0;
            description = ''
              0 -> normal (no transforms)
              1 -> 90 degrees
              2 -> 180 degrees
              3 -> 270 degrees
              4 -> flipped
              5 -> flipped + 90 degrees
              6 -> flipped + 180 degrees
              7 -> flipped + 270 degrees
            '';
          };
          scale = mkOption {
            type = types.int;
            default = 1;
            description = "The scale of this monitor";
          };
          mirror = mkOption {
            type = types.str;
            default = "";
            description = "If set, this monitor will mirror the specified one";
          };
          switch = mkOption {
            type = types.str;
            default = "";
            description = "Switch to trigger enable/disables for this monitor (Used by hyprland)";
          };
        };
      }
    );
    # defaults to no monitors
    default = [];
    description = "A list of monitors for this system";
  };

  config = mkIf (length cfg != 0) {
    assertions =
      [
        {
          assertion = ((length cfg) != 0) -> (length (filter (m: m.primary) cfg) == 1);
          message = "Exactly one monitor must be set to primary";
        }
      ]
      # Assertions for each monitor
      ++ concatLists (map (
          m: [
            {
              assertion = m.mirror == "" || (any (m2: m.mirror == m2.name) cfg);
              message = "\"${m.name}\" failed to mirror \"${m.mirror}\" because \"${m.mirror}\" does not exist.";
            }
            {
              assertion = length (filter (m2: m2.name == m.name) cfg) == 1;
              message = "\"${m.name}\" has an overlapping name with another monitor";
            }
          ]
        )
        cfg);
  };
}
