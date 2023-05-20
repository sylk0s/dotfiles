{ config, options, lib, pkgs, ...}: 
with lib;
with lib.my;
let
  cfg = config.modules.desktop.services.docker;
in {
  options.modules.desktop.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable) {

		virtualisation.docker = {
			enable = true;
		};

		virtualisation.docker.rootless = {
			enable = true;
			setSocketVariable = true;
		};

		users.users.${config.user.name}.extraGroups = [ "docker" ];

		user.packages = with pkgs; [
			docker-compose
		];
	};
}
