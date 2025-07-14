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

      #hibernate = {
      #enable = false;
      #resume-offset = 533760;
      #resume-device = "/dev/disk/by-label/NIXROOT";
      #};

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
          # I think when operating alone this should be *fine*?
          x-off = 1200 + 1920;
          y-off = 0;
        }
        # home desk config
        # TODO this may break with hyprland actually since hypr might not support this naming
        {
          # Sideways HP monitor
          name = "Hewlett Packard HP LP2475w CNC0090CVH";
          enable = true;
          x-off = 0;
          y-off = 0;
          transform = 3;
        }
        {
          # Normal lenovo monitor
          name = "Lenovo Group Limited LEN T2424zA V1K90974";
          enable = true;
          x-off = 1200;
          y-off = 235;
        }
      ];
    };

    services = {
      sops.enable = true;
      docker.enable = true;
      gpg.enable = true;
      git-crypt.enable = true;
      vmware.enable = true;
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
