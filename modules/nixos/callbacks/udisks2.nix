{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.services.udiskie.enable) config.home-manager.users) {
    services.udisks2 = {
      enable = true;
    };
  };
}
