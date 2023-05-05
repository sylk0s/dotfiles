{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.social.discord;
in {
  options.modules.desktop.social.discord = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      discord
    ];
  };
}
