# Global font configuration
{ config, options, lib, pkgs, ... }: 
with lib;
with lib.my;
let
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
      sub = font "Inter" 11;
      #serif = font "IBM Plex Serif" 11;
      mono = font "JuliaMono" 11;
      icons = font "Mononoki NF" 12;
      emoji = font "Noto Color Emoji" 12;
    };
  };

  # TODO add some option here for a light font install
  config = lib.mkIf (cfg.enable) {
    fonts = {
      packages = with pkgs; [
        inter
        (nerdfonts.override {
					fonts = [
						"JetBrainsMono"
						"Ubuntu"
						"Mononoki"
						#"FiraCode"
					];
				})
				julia-mono
				#ibm-plex
				noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        #material-design-icons
        #material-icons
        #font-awesome
      ];
      fontconfig = let
        styles = cfg.styles;
      in {
        enable = true;
        antialias = true;
        hinting = {
          enable = true;
          style = "medium";
          autohint = false;
        };
        defaultFonts = {
          sansSerif = ["${styles.main.family} ${toString styles.main.size}"];
          #serif = ["${styles.serif.family} ${toString styles.serif.size}"];
          monospace = ["${styles.mono.family} ${toString styles.mono.size}"];
          emoji = ["${styles.emoji.family} ${toString styles.emoji.size}"];
        };
      };
      enableDefaultPackages = true;
    };
  };
}
