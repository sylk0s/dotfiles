{
  lib,
  sylib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf filter listToAttrs;
  inherit (sylib) any-user filter-users;

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
    # systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    environment.persistence."${config.sylk.system.fs.impermanence.persist-dir}".users =
      listToAttrs
      (map (user: {
          name = "${user.name}";
          value = {
            directories = [
              ".local/share/Steam"
              ".local/share/vulkan"
              ".steam"
            ];
          };
        })
        (filter-users (user: user.modules.desktop.gaming.steam.enable) config.home-manager.users));
  };
}
