# Configuration for EWW (Elkowar's Wacky Widgets)
{ config, options, lib, pkgs, ...}: 
with lib;
with lib.my;
let
  cfg = config.modules.desktop.services.eww;

in {
  options.modules.desktop.services.eww = {
    enable = mkBoolOpt false;

		# Override to pkgs.eww for non-wayland DE
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.eww-wayland;
    };
  };

  config = let
    dependencies = with pkgs; [
      #ewwConfig.package
      #pkgs.sway
      #pkgs.swaysome
      #pkgs.bash
      #pkgs.bluez
      #pkgs.coreutils
      #pkgs.xdg-utils
      #pkgs.gawk
      #pkgs.gnugrep
      #pkgs.gnused
      #pkgs.procps
      #pkgs.findutils
      #pkgs.connman
      #pkgs.pulseaudio
      #pkgs.wireplumber
    ];
  in
    lib.mkIf (cfg.enable) {
      # home manager configuration
      home-manager.users.${config.user.name} = {
        programs.eww = {
          enable = true;
					package = cfg.package;
          configDir = "${config.dotfiles.configDir}/eww";
        };
      };

			environment.systemPackages = with pkgs; [
				jq
				socat
			];
    };
}
