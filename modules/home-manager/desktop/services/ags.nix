{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (sylib) mk-enable;
  cfg = config.sylk.desktop.services.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

  options.sylk.desktop.services.ags = {
    enable = mk-enable false;
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      home.packages = with pkgs; [
        sassc
        gnome-control-center
        gnome-bluetooth
        inotify-tools
        networkmanagerapplet
      ];

      programs.ags = {
        enable = true;
        configDir = "${inputs.self.outPath}/config/ags";
        extraPackages = with pkgs; [
          libsoup_3
          # the following were suggested from the wiki?
          gtksourceview
          webkitgtk
          accountsservice
        ];
      };

      # callback to callbacks/upower.nix
    })

    (mkIf (cfg.enable && osConfig.sylk.system.network.enable) {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    })
  ];
}
