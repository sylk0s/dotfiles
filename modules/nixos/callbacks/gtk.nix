{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  # TODO
  # config = mkIf (anyUsers (user: user.modules.themes.gtk.enable) config.home-manager.users) {
  #   programs.dconf.enable = true;
  # };
}
