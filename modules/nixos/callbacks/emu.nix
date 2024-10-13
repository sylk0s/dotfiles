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
  config = mkIf (any-user (user: user.modules.desktop.gaming.emu.enable) config.home-manager.users) {
    services.udev.packages = [pkgs.dolphinEmu];
  };
}
