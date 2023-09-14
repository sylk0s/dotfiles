{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.eza;
in {
  options.modules.shell.eza = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      eza
    ];

    environment.shellAliases = {
      ll = "eza -ll";
    };
  };
}
