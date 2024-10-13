{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.media.spotify.enable) config.home-manager.users) {
    networking.firewall.allowedTCPPorts = [57621];
  };
}
