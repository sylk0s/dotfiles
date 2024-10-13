{
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.desktop.security.wireshark;
in {
  options.modules.desktop.security.wireshark = {
    enable = mk-enable false;
  };

  # this one is... weird
  # this is just a callback, but i wanna be able to configure it so i can assert stuff about gui later
  # callback to callbacks/wireshark.nix
}
