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
    #grub.enable = true;
    disko = {
      enable = true;
      disko-config = ./disko.nix;
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

  home-manager.backupFileExtension = "backup";
  boot.supportedFilesystems = ["btrfs"];
}
