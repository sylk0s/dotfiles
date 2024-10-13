{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config =
    mkIf (any-users (user: user.modules.<AAA>.enable) config.home-manager.users) {
    };
}
