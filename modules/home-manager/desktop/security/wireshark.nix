{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.security.wireshark;
in {
  options.modules.desktop.security.wireshark = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users = {
      groups.wireshark = {};
      groups.plugdev = {};
      users.${config.user.name}.extraGroups = [
        "wireshark"
        "plugdev"
      ];
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
