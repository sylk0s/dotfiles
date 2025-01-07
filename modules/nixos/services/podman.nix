{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.services.podman;
in {
  options.sylk.services.podman = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };
  };
}
