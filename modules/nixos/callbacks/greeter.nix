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

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
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
