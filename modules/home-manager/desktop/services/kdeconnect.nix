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
  cfg = config.modules.desktop.services.kdeconnect;
in {
  options.modules.desktop.services.kdeconnect = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };

    home.persistence = {
      "/persist/home/${config.home.username}".directories = [".config/kdeconnect"];
    };
  };
}
