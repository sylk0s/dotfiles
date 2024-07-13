{
  config,
  options,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.sylkos) mkBoolOpt;
  cfg = config.modules.aaa;
in {
  options.modules.aaa = {
    enable = mkBoolOpt false;
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
