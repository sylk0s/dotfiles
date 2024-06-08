{
  config,
  osConfig,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.shell.neofetch;
in {
  options.modules.shell.neofetch = {
    enable = mkBoolOpt true;
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
