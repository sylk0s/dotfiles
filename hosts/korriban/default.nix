{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    # impermanence.enable = true;
    services = {
      docker.enable = true;
      gpg.enable = true;
      # sops.enable = true;
      kdeconnect.enable = true;
      # virtualbox.enable = true;
    };

    users = [
      {
        name = "sylkos";
        privileged = true;
        config = "${config.dotfiles.dir}/users/sylkos";
      }
    ];
  };
}
