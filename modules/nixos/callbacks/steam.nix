{
  lib,
  sylib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;

  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = mkIf (any-user (user: user.modules.desktop.gaming.steam.enable) config.home-manager.users) {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      opengl = {
        package = pkgs-unstable.mesa.drivers;

        # if you also want 32-bit support (e.g for Steam)
        driSupport32Bit = true;
        package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
      };
    };
  };
}
