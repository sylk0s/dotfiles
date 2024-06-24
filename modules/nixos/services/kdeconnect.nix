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
    # any assertations that should be checked
    #assertations = [
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
