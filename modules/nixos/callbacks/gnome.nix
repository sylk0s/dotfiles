{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.gnome.enable) config.home-manager.users) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
