{ config, options, lib, pkgs, ...}: 
with lib;
with lib.my;
let
  cfg = config.modules.desktop.services.udiskie;
in {
  options.modules.desktop.services.udiskie = {
    enable = mkBoolOpt true;
  };

  config = mkIf (cfg.enable) {
		services.udisks2.enable = true;

		home-manager.users.${config.user.name}.services.udiskie = {
			enable = true;
			automount = true;
		};
	};
}
