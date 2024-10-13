{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.security.wireshark.enable) config.home-manager.users) {
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
