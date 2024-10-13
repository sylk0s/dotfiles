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

  cfg = config.modules.network;
in {
  options.modules.network = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    # any assertions that should be checked
    # assertions = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];

    networking.networkmanager.enable = true;

    userDefaults.extraGroups = ["networkmanager"];

    # TODO Expand here with more netowrking things
  };
}
