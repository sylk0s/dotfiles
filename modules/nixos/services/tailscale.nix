{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  cfg = config.modules.services.tailscale;

  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.modules.services.tailscale = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
