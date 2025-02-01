{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (sylib) mk-enable;

  cfg = config.sylk.git-crypt;
in {
  options.sylk.git-crypt = {
    enable = mk-enable true;
  };

  config =
    mkIf cfg.enable {
    };
}
