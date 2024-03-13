{
  config,
  options,
  lib,
  pkgs,
  agenix,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.services.agenix;
in {
  options.modules.desktop.services.agenix = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [agenix.packages.x86_64-linux.default];
  };
}
