{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520
  ];

  sylk = {
    system = {
      audio.enable = true;
      bluetooth.enable = true;
      network.enable = true;

      nvidia = {
        enable = true;
        prime = {
          enable = true;
          intel-bus-id = "PCI:0:2:0";
          nvidia-bus-id = "PCI:1:0:0";
        };
      };

      boot.systemd-boot.enable = true;

      fs = {
        ephemeral-btrfs.enable = true;
        impermanence.enable = true;
        disko = {
          enable = true;
          config-file = ./disko.nix;
        };
      };

      monitors = [
        {
          name = "eDP-1";
          primary = true;
          enable = true;
          switch = "Lid Switch";
        }
      ];
    };

    services = {
      # sops.enable = true;
      docker.enable = true;
      gpg.enable = true;
    };
    ssh.enable = true;

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

  environment.systemPackages = with pkgs; [
    # mesa
  ];

  # time.timeZone = "Europe/Budapest";
}
