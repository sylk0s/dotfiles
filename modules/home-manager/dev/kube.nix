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
  cfg = config.modules.dev.kube;
in {
  options.modules.dev.kube = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lens
      kubectl
    ];
  };
}
