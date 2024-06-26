# Courtesy of Misterio77: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.monitors;
in {
  options.modules.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          primary = mkOption {
            type = types.bool;
            default = false;
          };
          width = mkOption {
            type = types.int;
            example = 1920;
          };
          height = mkOption {
            type = types.int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          x = mkOption {
            type = types.int;
            default = 0;
          };
          y = mkOption {
            type = types.int;
            default = 0;
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
          };
          workspace = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    # defaults to no monitors
    default = [];
  };

  config = mkIf (length cfg != 0) {
    # TODO Help?
    # any assertions that should be checked
    # assertions = [
    #       # assertion =
    # #           ((length cfg) != 0)
    # #           -> ((length (filter (m: m.primary) cfg)) == 1);
    # #         message = "Exactly one monitor must be set to primary.";
    #       # ...
    #     ];
    # other config ...
  };
}
