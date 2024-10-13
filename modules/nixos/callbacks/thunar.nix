{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.desktop.apps.thunar.enable) config.home-manager.users) {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
  };
}
