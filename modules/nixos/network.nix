{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.network;
in {
  options.modules.network = {
    enable = mkBoolOpt true;
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
