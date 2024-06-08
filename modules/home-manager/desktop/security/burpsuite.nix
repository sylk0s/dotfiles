{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.security.burpsuite;
in {
  options.modules.desktop.security.burpsuite = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      burpsuite
    ];
  };
}
