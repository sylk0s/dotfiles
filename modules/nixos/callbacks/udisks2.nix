{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.services.udiskie.enable) config.home-manager.users) {
    services.udisks2 = {
      enable = true;
    };
  };
}
