{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.desktop.social.thunderbird;
in {
  options.modules.desktop.social.thunderbird = {
    enable = mk-enable false;
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
