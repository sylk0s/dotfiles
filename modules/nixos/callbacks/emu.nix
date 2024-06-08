{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.gaming.emu.enable) config.home-manager.users) {
    services.udev.packages = [pkgs.dolphinEmu];
  };
}
