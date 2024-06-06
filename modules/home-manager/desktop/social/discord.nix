{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.desktop.social.discord;
in {
  options.modules.desktop.social.discord = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      webcord
    ];

    # TODO whatever addition stuff i want
  };
}
