{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.desktop.media.spotify.enable) config.home-manager.users) {
    networking.firewall.allowedTCPPorts = [57621];
  };
}
