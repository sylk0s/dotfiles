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
  config = mkIf (any-user (user: user.sylk.desktop.apps.hyprlock.enable) config.home-manager.users) {
    #hardware.opengl.enable = true;

    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = {}; # allows hyprlock to preform auth
  };
}
