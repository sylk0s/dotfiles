{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.services.kdeconnect;
in {
  options.modules.services.kdeconnect = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # any assertions that should be checked
    #assertions = [
    #  {
    #    assertion = true;
    #    message = "";
    #  }
      # ...
    #];
    # other config ...
    programs.kdeconnect.enable = true;
  };
}
