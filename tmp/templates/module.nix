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
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    # any assertations that should be checked
    assertations = [
      {
        assertion = true;
        message = "";
      }
      # ...
    ];
    # other config ...
  };
}
