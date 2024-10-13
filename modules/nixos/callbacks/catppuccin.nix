{
  lib,
  config,
  inputs,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-user;
in {
  imports = lib.trace "import catppuccin" [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  config = mkIf (any-user (user: user.modules.themes.catppuccin.enable) config.home-manager.users) {
    catppuccin = {
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };
  };
}
