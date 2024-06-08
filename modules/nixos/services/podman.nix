{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.services.podman;
in {
  options.modules.services.podman = {
    enable = mkBoolOpt false;
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
