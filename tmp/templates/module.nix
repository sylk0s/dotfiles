{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
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
