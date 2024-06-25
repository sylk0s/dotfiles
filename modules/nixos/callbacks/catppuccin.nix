{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.sylkos; {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  config =
    mkIf (anyUsers (user: user.modules.themes.catppuccin) config.home-manager.users) {
    };
}
