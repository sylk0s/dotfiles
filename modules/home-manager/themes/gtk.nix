{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.themes.gtk;
  srv = config.services;
in {
  #   options.modules.themes.gtk = {
  #     enable = mkBoolOpt true;
  #     iconTheme = {
  #       name = mkStrOpt "Papirus-Dark";
  #       package = lib.mkOption {
  #         type = lib.types.package;
  #         default = pkgs.catppuccin-papirus-folders.override {
  #           flavor = "mocha";
  #           accent = "lavender";
  #         };
  #       };
  #     };
  #     theme = {
  #       name = mkStrOpt "Catppuccin-Mocha-Compact-Lavender-Dark";
  #       package = lib.mkOption {
  #         type = lib.types.package;
  #         default = pkgs.catppuccin-gtk.override {
  #           accents = ["lavender"];
  #           size = "compact";
  #           tweaks = [];
  #           variant = "mocha";
  #         };
  #       };
  #     };
  #   };

  #   config = mkIf (config.modules.desktop.hyprland.enable) {
  #     gtk = {
  #       enable = true;

  #       iconTheme = {
  #         name = cfg.iconTheme.name;
  #         package = cfg.iconTheme.package;
  #       };

  #       theme = {
  #         name = cfg.theme.name;
  #         package = cfg.theme.package;
  #       };

  #       gtk3.extraConfig = {
  #         gtk-application-prefer-dark-theme = 1;
  #       };

  #       gtk4.extraConfig = {
  #         gtk-application-prefer-dark-theme = 1;
  #       };
  #     };
  #   };
}
