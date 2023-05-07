# Configuration for EWW (Elkowar's Wacky Widgets)
{ config, options, lib, pkgs, ...}: 
with lib;
with lib.my;
let
  cfg = config.modules.desktop.services.eww;

in {
  options.modules.desktop.services.eww = {
    enable = mkBoolOpt false;
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.eww-wayland;
    };
  };

  config = let
    dependencies = [
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
      #pkgs.jq
      #pkgs.networkmanager
      #pkgs.connman
      #pkgs.pulseaudio
      #pkgs.wireplumber
    ];
  in
    lib.mkIf (cfg.enable) {
      # home manager configuration
      home-manager.users.${config.user.name} = {
      # TODO switch between wayland and X
        programs.eww = {
          enable = true;
					package = cfg.package;
          configDir = "${config.dotfiles.configDir}/eww";
        };

        #systemd.user.services.eww = {
        #  Unit = {
        #    Description = "Eww Daemon";
        #    PartOf = ["graphical-session.target"];
        #  };
        #  Service = {
        #    Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        #    ExecStart = "${ewwConfig.package}/bin/eww daemon --no-daemonize";
        #    Restart = "on-failure";
        #  };
        #  Install.WantedBy = ["graphical-session.target"];
        #};
      };
    };
}
