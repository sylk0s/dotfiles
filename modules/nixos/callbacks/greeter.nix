{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
# TODO abstract over desktop
  config = mkIf (any-user (user: user.sylk.desktop.hyprland.enable || user.sylk.desktop.niri.enable) config.home-manager.users) {
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

    # services.greetd = {
    #   enable = true;
    # };

    # programs.regreet = {
    #   enable = true;
    # };

    # services.displayManager = {
    # sddm = {
    #   enable = true;
    #   wayland.enable = true;
    #   package = pkgs.kdePackages.sddm;
    # };
    # ly = {
    #   enable = true;
    #   };
    # };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
          user = "greeter";
        };
      };
    };

    sylk.system.fs.impermanence.dirs-to-persist = [
      "/var/cache/tuigreet"
    ];

    #systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";

    boot.plymouth = {
      enable = true;
    };
  };
}
