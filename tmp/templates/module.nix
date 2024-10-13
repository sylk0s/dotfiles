{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.aaa;
in {
  options.modules.aaa = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # any assertions that should be checked
    assertions = [
      {
        assertion = true;
        message = "";
      }
      # ...
    ];
    # other config ...
  };
}
