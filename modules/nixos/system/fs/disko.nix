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

  cfg = config.sylk.system.fs.disko;
in {
  imports = [inputs.disko.nixosModules.disko];

  options.sylk.system.fs.disko = {
    enable = mk-enable false;
    config-file = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    inherit (import cfg.config-file) disko;

    fileSystems = {
      "${config.sylk.system.fs.impermanence.persist-dir}".neededForBoot = true;
      "/var/log".neededForBoot = true;
      "/home".neededForBoot = true;
    };
  };
}
