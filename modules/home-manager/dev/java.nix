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

  cfg = config.modules.dev.java;
in {
  options.modules.dev.java = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      openjdk17
    ];
  };
}
