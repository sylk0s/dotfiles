{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps;
in {
  config = {
    user.packages = with pkgs; [
      gimp
      icon-library
      networkmanagerapplet
      brightnessctl
    ];
  };
}
