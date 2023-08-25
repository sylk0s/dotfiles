{ config, options, lib, pkgs, ...}: 

with lib;
with lib.my;
let cfg = config.modules.themes.gtk;
    srv = config.services;
in {
  options.modules.themes.gtk = {
    enable = mkBoolOpt true;
		iconTheme = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.catppuccin-papirus-folders.override {
					flavor = "mocha";
					accent = "lavender";
				};
      };
      name = mkStrOpt "Papirus-Dark";
    };
  };

  config = mkIf (srv.xserver.enable || config.modules.desktop.hyprland.enable) {

    home-manager.users.${config.user.name} = {
      gtk = {
        enable = true;

        iconTheme = {
          name = cfg.iconTheme.name;
          package = cfg.iconTheme.package;
        };

        theme = {
          name = "Catppuccin-Mocha-Compact-Lavender-dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "lavender" ];
            size = "compact";
            tweaks = [ "rimless" "black" ];
            variant = "mocha";
          };
        };


        gtk3.extraConfig = {
					gtk-application-prefer-dark-theme = 1;
        };

        gtk4.extraConfig = {
					gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
