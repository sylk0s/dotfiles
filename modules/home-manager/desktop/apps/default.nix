{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.apps;
in {
  config = {
    # TODO
    # home.packages = with pkgs; [
    #   gimp
    #   icon-library
    #   brightnessctl
    # ];
  };
}
