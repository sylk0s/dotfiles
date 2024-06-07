{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.themes.gtk.enable) config.home-manager.users) {
    programs.dconf.enable = true;
  };
}
