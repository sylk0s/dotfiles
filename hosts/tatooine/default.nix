{
  pkgs,
  config,
  lib,
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # does not exist yet, needs to be created
  ];

  modules = {
    network.enable = true;
    impermanence.enable = true;
    systemd-boot.enable = true;
    services.disko = {
      enable = true;
      config-file = ./disko.nix;
    };

    users = [
      {
        name = "test";
        privileged = true;
        config = "${inputs.self.outPath}/users/test";
      }
    ];
  };

  boot.supportedFilesystems = ["btrfs"];
}
