{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.bat;
in {
  options.modules.shell.bat = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bat
    ];

    environment.shellAliases = {
      cat = "bat --paging=never";
      catp = "bat -p --paging=never";
    };
  };
}
