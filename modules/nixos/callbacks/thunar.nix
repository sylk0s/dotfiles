{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.apps.thunar.enable) config.home-manager.users) {
    services.tumbler.enable = true;
    services.gvfs.enable = true;
  };
}
