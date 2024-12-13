{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf types mkOption;
  inherit (sylib) mk-enable;
  cfg = config.modules.services.disko;
in {
  imports = [inputs.disko.nixosModules.disko];

  options.modules.services.disko = {
    enable = mk-enable false;
    config = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    inherit (import cfg.config) disko;

    fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };
  };
}
