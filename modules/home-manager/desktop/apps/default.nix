{
  config,
  options,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sylk.desktop.apps;
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
