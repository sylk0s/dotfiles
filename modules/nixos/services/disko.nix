{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.services.disko;
in {
  imports = [inputs.disko.nixosModules.disko];

  options.modules.services.disko = {
    enable = mk-enable false;
    # config =
  };

  config =
    mkIf cfg.enable {
    };
}
