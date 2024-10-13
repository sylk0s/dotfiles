{
  lib,
  sylib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.gaming.steam.enable) config.home-manager.users) {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
