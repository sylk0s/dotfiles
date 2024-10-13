{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  cfg = config.modules.desktop.cosmic;
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.modules.desktop.cosmic = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # callback to callbacks/cosmic.nix
  };
}
