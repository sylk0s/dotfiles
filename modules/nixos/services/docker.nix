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
  cfg = config.sylk.services.docker;
in {
  options.sylk.services.docker = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    virtualisation.docker = {
      enable = true;
    };

    sylk.userDefaults.extraGroups = ["docker"];

    # TODO figure this bit out
    # user.packages = with pkgs; [
    #   docker-compose
    # ];
  };
}
