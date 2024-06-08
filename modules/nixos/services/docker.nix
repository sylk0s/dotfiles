{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
    enable = mkBoolOpt false;
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
