{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.apps.thunar.enable) config.home-manager.users) {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
  };
}
