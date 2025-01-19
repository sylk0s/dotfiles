{
  config,
  osConfig,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.shell.neofetch;
in {
  options.sylk.shell.neofetch = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        neofetch
      ];

      shellAliases = {
        neofetch = "neofetch --config ${inputs.self.outPath}/config//neofetch/config.conf";
      };
    };
  };
}
