{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
  ];

  modules = {
    #    audio.enable = true;
    #    bluetooth.enable = true;
    network.enable = true;

    users = [
      {
        name = "sylkos";
        priviledged = true;
        config = "${config.dotfiles.dir}/users/test";
      }
    ];
  };

  boot = {
    initrd = {
      luks.devices = {
        "test_crypt" = {
          device = "/dev/disk/by-uuid/adff35ba-a59f-44d8-adeb-322ba5c681cf";
          preLVM = true;
        };
      };
    };
  };

  boot.supportedFilesystems = ["btrfs"];
}
