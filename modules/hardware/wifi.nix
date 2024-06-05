{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.hardware.wifi;
in {
  options.modules.hardware.wifi = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
