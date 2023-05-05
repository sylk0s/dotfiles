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
		services.udiskie = {
			enable = true;
			automount = true;
		};
	};
}
