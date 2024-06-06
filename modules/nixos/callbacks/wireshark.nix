{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.security.wireshark.enable) config.home-manager.users) {
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
