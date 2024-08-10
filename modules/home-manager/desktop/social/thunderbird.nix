{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.social.thunderbird;
in {
  options.modules.desktop.social.thunderbird = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # programs.thunderbird = {
    #   enable = true;
    #   profiles = {
    #     "${config.home.username}" = {
    #       name = "${config.home.username}";
    #     };
    #   };
    # };
  };
}
