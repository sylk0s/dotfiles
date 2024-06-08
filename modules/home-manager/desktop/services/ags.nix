{
  config,
  osConfig,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.services.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];

  options.modules.desktop.services.ags = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      home.packages = with pkgs; [
        sassc
        gnome.gnome-control-center
        gnome.gnome-bluetooth
        inotify-tools
        networkmanagerapplet
      ];

      programs.ags = {
        enable = true;
        configDir = "${osConfig.dotfiles.configDir}/ags";
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

    (mkIf (cfg.enable && osConfig.modules.network.enable) {
      home.packages = with pkgs; [
        networkmanagerapplet
      ];
    })
  ];
}
