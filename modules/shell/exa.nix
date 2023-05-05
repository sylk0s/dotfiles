{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.exa;
in {
  options.modules.shell.exa = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      exa
    ];

    environment.shellAliases = {
      ll = "exa -ll";
    };
  };
}
