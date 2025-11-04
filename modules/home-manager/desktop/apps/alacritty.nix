# Configuration for the Alacritty terminal
{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.desktop.apps.alacritty;
in {
  options.sylk.desktop.apps.alacritty = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    # home manager configuration

    programs.alacritty = {
      enable = true;
      settings = {
        # window settings
        window = {
          padding = {
            x = 4;
            y = 4;
          };
          dynamic_padding = true;
          # opacity = 1;
        };

        # max lines in buffer
        scrolling.history = 10000;

        # font config
        font = {
          size = 11;
        };

        # colorscheme
        colors = {
          draw_bold_text_with_bright_colors = true;
        };

        # selection settings
        selection.save_to_clipboard = true;

        # cursor settings
        cursor = {
          style.shape = "Beam";
          # unfocused_follow = false;
        };

        # mouse settings
        mouse.bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];

        # key bindings
        keyboard.bindings = [
          {
            key = "V";
            mods = "Control|Shift";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Shift";
            action = "Copy";
          }
        ];
      };
    };

    #xdg.configFile.alacritty.source = alacritty;
  };
}
