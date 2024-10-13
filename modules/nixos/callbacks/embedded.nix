{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.dev.embedded.enable) config.home-manager.users) {
    services.udev.packages = with pkgs; [
      platformio-core
      openocd
    ];

    userDefaults.extraGroups = ["dialout"];
  };
}
