{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (builtins) foldl';
  inherit (lib) length filter;
  inherit (sylib) attrs-to-list;

  bootloaders = attrs-to-list config.sylk.boot;
  enabled-bootloaders = filter (bl: bl.enable) bootloaders;
  enabled-bootloader-names = foldl' (s: bl: "${bl.name} ${s}") "" enabled-bootloaders;
in {
  config = {
    assertions = [
      {
        assertion = (length enabled-bootloaders) != 0;
        message = "No bootloader selected";
      }
      {
        assertion = (length enabled-bootloaders) == 1;
        message = "Multiple bootloaders enabled: [ ${enabled-bootloader-names}]";
      }
    ];
  };
}
