{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.dev.embedded.enable) config.home-manager.users) {
    services.udev.packages = with pkgs; [
      platformio-core
      openocd
    ];

    userDefaults.extraGroups = ["dialout"];
  };
}
