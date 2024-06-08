# Global font configuration
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.themes.fonts;
  font = defaultFamily: defaultSize: {
    family = mkStrOpt defaultFamily;
    size = lib.mkOption {
      type = lib.types.int;
      default = defaultSize;
    };
  };
in {
  options.modules.themes.fonts = {
    enable = mkBoolOpt true;

    styles = {
      main = font "Ubuntu Nerd Font" 11;
      serif = font "IBM Plex Serif" 11;
      mono = font "JuliaMono" 11;
      emoji = font "Noto Color Emoji" 12;
    };
  };

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Ubuntu"
        ];
      })
      julia-mono
      ibm-plex
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    fonts = {
      fontconfig = let
        styles = cfg.styles;
      in {
        enable = true;
        defaultFonts = {
          sansSerif = ["${styles.main.family} ${toString styles.main.size}"];
          serif = ["${styles.serif.family} ${toString styles.serif.size}"];
          monospace = ["${styles.mono.family} ${toString styles.mono.size}"];
          emoji = ["${styles.emoji.family} ${toString styles.emoji.size}"];
        };
      };
    };
  };
}
