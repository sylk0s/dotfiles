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
      nvidia.enable = true;

      boot.systemd-boot.enable = true;

      fs = {
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
        }
      ];
    };

    services = {
      sops.enable = true;
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
    mesa
  ];

  # time.timeZone = "Europe/Budapest";
}
