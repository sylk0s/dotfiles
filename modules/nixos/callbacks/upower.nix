{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.services.ags.enable) config.home-manager.users) {
    services.upower.enable = true;
  };
}
