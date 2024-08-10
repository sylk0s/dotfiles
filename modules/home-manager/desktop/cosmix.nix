{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.cosmic;
in {
  options.modules.desktop.cosmic = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # callback to callbacks/cosmic.nix
  };
}
