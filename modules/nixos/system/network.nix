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

  cfg = config.sylk.system.network;
in {
  options.sylk.system.network = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    userDefaults.extraGroups = ["networkmanager"];
  };
}
