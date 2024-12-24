{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520
  ];

  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    impermanence = {
      enable = true;
      device = "cryptid";
    };

    # lanzaboote.enable = true;
    systemd-boot.enable = true;
    services = {
      disko = {
        enable = true;
        config-file = ./disko.nix;
      };
    };

    users = [
      {
        name = "sylkos";
        privileged = true;
        config = "${inputs.self.outPath}/users/sylkos";
      }
    ];
  };

  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "mocha";
  };

  # time.timeZone = "Europe/Budapest";
}
