{
  inputs,
  sylib,
  config,
  ...
}: let
  inherit (sylib) mk-enable mk-opt;
  inherit (lib) types mkIf;

  cfg = config.modules.disko;
in {
  imports = [inputs.disko.nixosModules.disko];

  options.modules.disko = {
    enable = mk-enable false;
    disko-config = mk-opt (types.nullOr types.str) null "The path to the disko config";
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;

  config = mkIf cgf.enable {
    inherit (import config.modules.disko.disko-config);
  };
}
