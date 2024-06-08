{
  lib,
  config,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.media.spotify.enable) config.home-manager.users) {
    networking.firewall.allowedTCPPorts = [57621];
  };
}
