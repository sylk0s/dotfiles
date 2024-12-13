{
  pkgs,
  config,
  lib,
  inputs,
  self,
  ...
}: {
  imports = [
    #./hardware-configuration.nix
  ];

  modules = {
    #    audio.enable = true;
    #    bluetooth.enable = true;
    network.enable = true;
    #impermanence.enable = true;
    grub.enable = true;
    services.disko = {
      enable = true;
      config-file = ./disko.nix;
    };
    #services = {
    #sops.enable = true;
    #gpg.enable = true;
    #};

    users = [
      {
        name = "test";
        privileged = true;
        config = "${inputs.self.outPath}/users/test";
      }
    ];
  };

  boot.loader.grub.enableCryptodisk = false;

  home-manager.backupFileExtension = "backup";
  boot.supportedFilesystems = ["btrfs"];
}
