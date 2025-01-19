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

  cfg = config.sylk.shell.eza;
in {
  options.sylk.shell.eza = {
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
