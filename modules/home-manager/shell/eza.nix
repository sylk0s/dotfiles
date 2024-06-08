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
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      # TODO explore these
    };

    home.shellAliases = {
      ll = "eza -ll";
      tree = "eza --tree";
    };
  };
}
