{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.sylkos) mkBoolOpt;
  cfg = config.modules.desktop.services.kdeconnect;
in {
  options.modules.desktop.services.kdeconnect = {
    enable = mkBoolOpt false;
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
