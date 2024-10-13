{
  config,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.services.agenix;
in {
  options.modules.services.agenix = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    #  = [
    #   inputs.agenix.packages.x86_64-linux.default
    # ];
  };
}
