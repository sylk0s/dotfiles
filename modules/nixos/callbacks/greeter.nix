{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.hyprland.enable) config.home-manager.users) {
    # TODO use something besides this
    # TODO also use plymouth for pretty splash
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "Hyprland";
    #     };
    #   };
    # };

    # environment.etc."greetd/environments".text = ''
    #   Hyprland
    #   zsh
    #   bash
    # '';

    # programs.regreet = {
    #   enable = true;

    #   cageArgs = ["-s" "-m" "last"];

    #   settings = {
    #     background = {
    #       path = "${config.dotfiles.configDir}/assets/wallpapers/astro.png";
    #       fit = "Contain";
    #     };

    #     GTK = {
    #       application_prefer_dark_theme = true;
    #       icon_theme_name = "Papirus-Dark";
    #       theme_name = "catppuccin-mocha-lavender-compact+default";
    #     };

    #     commands = {
    #       reboot = ["systemctl" "reboot"];
    #       poweroff = ["systemctl" "poweroff"];
    #     };
    #   };
    # };

    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
    };

    boot.plymouth = {
      enable = true;
    };
  };
}
