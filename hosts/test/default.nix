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
}
