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

  cfg = config.modules.shell.eza;
in {
  options.modules.shell.eza = {
    enable = mk-enable false;
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
