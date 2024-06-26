{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    #    audio.enable = true;
    #    bluetooth.enable = true;
    network.enable = true;
    impermanence.enable = true;
    services = {
      sops.enable = true;
      gpg.enable = true;
    };

    users = [
      {
        name = "sylkos";
        privileged = true;
        config = "${config.dotfiles.dir}/users/test";
      }
    ];
  };

  boot = {
    initrd = {
      luks.devices = {
        "test_crypt" = {
          device = "/dev/disk/by-uuid/1cc8bd73-a0f2-47d5-b9b2-b1dd5d0c0aa4";
          preLVM = true;
        };
      };
    };
  };

  home-manager.backupFileExtension = "backup";
  boot.supportedFilesystems = ["btrfs"];
}
