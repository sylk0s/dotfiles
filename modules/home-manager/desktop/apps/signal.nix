{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  cfg = config.sylk.desktop.social.signal;

  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.sylk.desktop.social.signal = {
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
