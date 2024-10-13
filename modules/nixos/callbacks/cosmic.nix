{
  lib,
  sylib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = mkIf (any-users (user: user.modules.desktop.cosmic.enable) config.home-manager.users) {
    services.desktopManager = {
      cosmic.enable = true;
    };
    services.displayManager.cosmic-greeter.enable = true;
  };
}
