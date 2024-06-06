{
  config,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.services.agenix;
in {
  options.modules.desktop.services.agenix = {
    enable = mkBoolOpt false;
  };

  config = mkIf (cfg.enable) {
    user.packages = [
      inputs.agenix.packages.x86_64-linux.default
    ];
  };
}
