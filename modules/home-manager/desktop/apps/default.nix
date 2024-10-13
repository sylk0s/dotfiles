{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
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
