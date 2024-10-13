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
  config = mkIf (any-users (user: user.modules.desktop.gaming.emu.enable) config.home-manager.users) {
    services.udev.packages = [pkgs.dolphinEmu];
  };
}
