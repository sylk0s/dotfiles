{
  lib,
  sylib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (sylib) any-user;
in {
  imports = [inputs.niri.nixosModules.niri];

  config = mkMerge [
    {nixpkgs.overlays = [inputs.niri.overlays.niri];}
    (mkIf (any-user (user: user.sylk.desktop.niri.enable) config.home-manager.users) {
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
    })
  ];
}
