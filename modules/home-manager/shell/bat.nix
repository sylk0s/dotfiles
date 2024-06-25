{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.bat;
in {
  options.modules.shell.bat = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      # config.theme = "ansi";
    };

    home.shellAliases = {
      cat = "bat -P -p";
      cata = "bat -P";
      catv = "bat -P -A";
    };
  };
}
