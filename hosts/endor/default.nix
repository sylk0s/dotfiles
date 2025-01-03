{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520
    # ./nvidia.nix
  ];

  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    systemd-boot.enable = true;

    impermanence.enable = true;
    services = {
      disko = {
        enable = true;
        config-file = ./disko.nix;
      };
      sops.enable = true;
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
