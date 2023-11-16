{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.python;
  my-python-packages = ps:
    with ps; [
      # other python packages
      ipykernel
      numpy
      pip
      matplotlib
      scipy
      cloudflare
      requests
      python-dotenv
    ];
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (python3.withPackages my-python-packages)
    ];
  };
}
