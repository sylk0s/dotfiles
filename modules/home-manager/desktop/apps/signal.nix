{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.social.signal;

  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.modules.desktop.social.signal = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        signal-desktop
      ];
      persistence."/persist/home/${config.home.username}" = {
        directories = [
          ".config/Signal"
        ];
      };
    };
  };
}
