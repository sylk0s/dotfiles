{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  cfg = config.sylk.services.tailscale;

  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.sylk.services.tailscale = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    # going to add more tailscale bullshit later!
  };
}
