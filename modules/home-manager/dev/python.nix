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

  cfg = config.modules.dev.python;
  my-python-packages = ps:
    with ps; [
      numpy
      pip
      matplotlib
      scipy
      requests
      python-dotenv
    ];
in {
  options.modules.dev.python = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (python3.withPackages my-python-packages)
    ];
  };
}
