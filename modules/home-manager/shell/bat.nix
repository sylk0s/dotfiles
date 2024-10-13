{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.modules.shell.bat;
in {
  options.modules.shell.bat = {
    enable = mk-enable true;
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
