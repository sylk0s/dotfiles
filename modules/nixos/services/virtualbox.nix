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

  cfg = config.modules.services.virtualbox;
in {
  options.modules.services.virtualbox = {
    enable = mk-enable false;
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
