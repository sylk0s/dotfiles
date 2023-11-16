{
  config,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.services.ags;
in {
  options.modules.desktop.services.ags = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      sassc
      gnome.gnome-control-center
    ];

    services.upower.enable = true;

    home-manager.users.${config.user.name} = {
      # add the home manager module
      imports = [inputs.ags.homeManagerModules.default];

      programs.ags = {
        enable = true;
        configDir = "${config.dotfiles.configDir}/ags";
        extraPackages = with pkgs; [
          libsoup_3
        ];
      };

      # xdg.desktopEntries."org.gnome.Settings" = {
      #     name = "Settings";
      #     comment = "Gnome Control Center";
      #     icon = "org.gnome.Settings";
      #     exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
      #     categories = [ "X-Preferences" ];
      #     terminal = false;
      # };

      # dconf = {
      #     settings = {
      #         "org.gnome.desktop.default-applications" = {
      #             terminal = "alacritty";
      #         };
      #     };
      # };
    };
  };
}
