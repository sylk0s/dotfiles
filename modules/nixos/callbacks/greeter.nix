{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.hyprland.enable) config.home-manager.users) {
    # TODO use something besides this
    # TODO also use plymouth for pretty splash
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "cage -s -- regreet";
    #       user = "greeter";
    #     };
    #   };
    # };

    programs.regreet = {
      enable = true;

      cageArgs = ["-s" "-m" "last"];

      settings = {
        background = {
          path = "${config.dotfiles.configDir}/assets/wallpapers/astro.png";
          fit = "Contain";
        };

        GTK = {
          application_prefer_dark_theme = true;
          icon_theme_name = "Papirus-Dark";
          theme_name = "Catppuccin-Mocha-Compact-Lavender-Dark";
        };

        commands = {
          reboot = ["systemctl" "reboot"];
          poweroff = ["systemctl" "poweroff"];
        };
      };
    };
  };
}
