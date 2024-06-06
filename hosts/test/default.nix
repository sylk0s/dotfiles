{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    # PUT HW CONF HERE!
  ];

  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    users = [
      {
        name = "sylkos";
        priviledged = true;
        config = "${config.dotfiles.dir}/users/sylkos";
      }
    ];
  };
}
