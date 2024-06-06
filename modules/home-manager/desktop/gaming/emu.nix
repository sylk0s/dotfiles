{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.gaming.emu;
in {
  options.modules.desktop.gaming.emu = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      dolphin-emu
      lutris
    ];

    services.udev.packages = [pkgs.dolphinEmu];
  };
}
