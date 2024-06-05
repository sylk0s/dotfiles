{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.aaa.bbb;
in {
  options.modules.aaa.bbb = {
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
