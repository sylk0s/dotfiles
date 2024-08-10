{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.sylkos; {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  config = mkIf (anyUsers (user: user.modules.desktop.cosmic.enable) config.home-manager.users) {
    services.desktopManager = {
      cosmic.enable = true;
      cosmic-greeter.enable = true;
    };
  };
}
