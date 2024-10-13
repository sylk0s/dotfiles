{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.desktop.services.ags.enable) config.home-manager.users) {
    services.upower.enable = true;
  };
}
