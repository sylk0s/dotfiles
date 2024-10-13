{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.dev.embedded.enable) config.home-manager.users) {
    services.udev.packages = with pkgs; [
      platformio-core
      openocd
    ];

    userDefaults.extraGroups = ["dialout"];
  };
}
