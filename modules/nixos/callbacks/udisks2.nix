{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.desktop.services.udiskie.enable) config.home-manager.users) {
    services.udisks2 = {
      enable = true;
    };
  };
}
