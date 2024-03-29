{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.services.podman;
in {
  options.modules.desktop.services.podman = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable) {
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };

    user.packages = with pkgs; [
      #docker-compose
    ];
  };
}
