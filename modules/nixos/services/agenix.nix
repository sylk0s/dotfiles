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
  cfg = config.sylk.services.agenix;
in {
  options.sylk.services.agenix = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    #  = [
    #   inputs.agenix.packages.x86_64-linux.default
    # ];
  };
}
