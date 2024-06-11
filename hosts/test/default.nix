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
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    users = [
      {
        name = "sylkos";
        priviledged = true;
        config = "${config.dotfiles.dir}/users/test";
      }
    ];
  };

  initrd = {
    luks.devices = {
      "test_crypt" = {
        device = "/dev/disk/by-uuid/UUID";
        preLVM = true;
      };
    };
  };

  supportedFilesystems = ["btrfs"];
}
