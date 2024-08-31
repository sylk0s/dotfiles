{
  config,
  options,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.sylkos) mkBoolOpt;
  cfg = config.modules.services.disko;
in {
  imports = [inputs.disko.nixosModules.disko];

  options.modules.services.disko = {
    enable = mkBoolOpt false;
    # config =
  };

  config =
    mkIf cfg.enable {
    };
}
