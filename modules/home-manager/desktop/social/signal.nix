{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.social.signal;
in {
  options.modules.desktop.social.signal = {
    enable = mkBoolOpt false;
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
