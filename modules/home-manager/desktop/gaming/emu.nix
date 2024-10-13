{
  options,
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.gaming.emu;
in {
  options.modules.desktop.gaming.emu = with types; {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dolphin-emu
      lutris
    ];

    # callback to callbacks/emu.nix
  };
}
