{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  # TODO
  # config = mkIf (any-user (user: user.modules.themes.gtk.enable) config.home-manager.users) {
  #   programs.dconf.enable = true;
  # };
}
