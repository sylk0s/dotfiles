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
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # discord
        # webcord
        vesktop
      ];

      persistence."/persist/home/${config.home.username}" = {
        directories = [
          ".config/vesktop"
          # ".config/vesktop/sessionData"
          # ".config/vesktop/settings"
        ];
      };
    };

    xdg.configFile."vesktop/themes/catppuccin.css".text = ''@import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-pink.theme.css");'';
  };
}
