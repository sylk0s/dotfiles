{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
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
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (python3.withPackages my-python-packages)
    ];
  };
}
