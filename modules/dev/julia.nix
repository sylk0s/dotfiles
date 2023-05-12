{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.julia;
in {
  options.modules.dev.julia = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      julia-bin
    ];
  };
}
