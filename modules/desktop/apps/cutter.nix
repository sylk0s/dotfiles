{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.cutter;
in {
  options.modules.desktop.apps.cutter = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (cutter.withPlugins (ps: with ps; [jsdec rz-ghidra sigdb]))
    ];
  };
}
