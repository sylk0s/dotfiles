{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config =
    mkIf (any-user (user: user.modules.<AAA>.enable) config.home-manager.users) {
    };
}
