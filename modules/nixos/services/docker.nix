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
  cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    virtualisation.docker = {
      enable = true;
    };

    userDefaults.extraGroups = ["docker"];

    # TODO figure this bit out
    # user.packages = with pkgs; [
    #   docker-compose
    # ];
  };
}
