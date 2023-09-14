{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.virtualbox;
in {
  options.modules.desktop.apps.virtualbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
		virtualisation.virtualbox.host.enable = true;
		virtualisation.virtualbox.host.enableExtensionPack = true;
		users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  };
}
