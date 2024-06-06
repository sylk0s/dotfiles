{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO
    # eventually i wanna move this here

    # for now...
    # callback to callbacks/steam.nix
  };
}
