{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.apps.virtualbox;
in {
  options.modules.services.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;

    # USB support, but also recompiles a Lot :(
    # virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = ["user-with-access-to-virtualbox"];

    userDefaults.extraGroups = ["vboxusers"];

    networking.firewall.interfaces."vboxnet0".allowedTCPPorts = [22];

    # currently, all users are able to use this by default if enabled
  };
}
