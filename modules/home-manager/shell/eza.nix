{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.eza;
in {
  options.modules.shell.eza = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      eza
    ];

    shellAliases = {
      ll = "eza -ll";
      tree = "eza --tree";
    };
  };
}
