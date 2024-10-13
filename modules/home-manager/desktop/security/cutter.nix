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
  cfg = config.modules.desktop.security.cutter;
in {
  options.modules.desktop.security.cutter = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (cutter.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    ];
  };
}
