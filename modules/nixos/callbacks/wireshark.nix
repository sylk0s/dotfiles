{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  config = mkIf (any-user (user: user.modules.desktop.security.wireshark.enable) config.home-manager.users) {
    users.groups.plugdev = {};
    userDefaults.extraGroups = [
      "wireshark"
      "plugdev"
    ];

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
