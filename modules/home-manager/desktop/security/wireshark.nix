{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.security.wireshark;
in {
  options.modules.desktop.security.wireshark = {
    enable = mkBoolOpt false;
  };

  # this one is... weird
  # this is just a callback, but i wanna be able to configure it so i can assert stuff about gui later
  # callback to callbacks/wireshark.nix
}
