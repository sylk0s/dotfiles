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
  cfg = config.modules.desktop.social.fractal;
in {
  options.modules.desktop.social.fractal = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    services.gnome-keyring.enable = true;
    home = {
      packages = with pkgs; [
        fractal
      ];

      # persistence."/persist/home/${config.home.username}" = {
      #   directories = [
      #     ".config/vesktop"
      #     # ".config/vesktop/sessionData"
      #     # ".config/vesktop/settings"
      #   ];
      # };
    };

    # xdg.configFile."vesktop/themes/catppuccin.css".text = ''@import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha-pink.theme.css");'';
  };
}
