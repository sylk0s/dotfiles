{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.modules.shell.neofetch;
in {
  options.modules.shell.neofetch = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        neofetch
      ];

      shellAliases = {
        neofetch = "neofetch --config ${osConfig.dotfiles.configDir}/neofetch/config.conf";
      };
    };
  };
}
