# Configuration for EWW (Elkowar's Wacky Widgets)
{
  config,
  osConfig,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (sylib) mk-enable mk-str-opt;
  cfg = config.modules.desktop.services.eww;
in {
  options.modules.desktop.services.eww = {
    enable = mk-enable false;

    # Override to pkgs.eww for non-wayland DE
    package = mkOption {
      type = types.package;
      default = pkgs.eww-wayland;
    };

    # layout name... probably later should implement this as the script or something
    layout = mk-str-opt "leftbar";
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
    mkIf (cfg.enable) {
      # home manager configuration

      programs.eww = {
        enable = true;
        package = cfg.package;
        configDir = "${osConfig.dotfiles.configDir}/eww";
      };

      home.packages = with pkgs; [
        jq
        socat
      ];
    };
}
