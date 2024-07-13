{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.sylkos) anyUsers;
in {
  config =
    mkIf (anyUsers (user: user.modules.aaa.enable) config.home-manager.users) {
    };
}
