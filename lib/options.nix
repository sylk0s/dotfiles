{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in rec {
  mk-opt = type: default: description:
    mkOption {inherit type default description;};

  mk-bool-opt = default:
    mkOption {
      inherit default;
      type = types.bool;
    };

  mk-str-opt = default:
    mkOption {
      inherit default;
      type = types.str;
    };

  mk-enable = default: mk-bool-opt default;
}
