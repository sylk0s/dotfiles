{
  options,
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.desktop.gaming.mc;
in {
  options.modules.desktop.gaming.mc = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        tomlplusplus
        prismlauncher
      ];
      persistence."/persist/home/${config.home.username}" = {
        directories = [
          ".local/share/PrismLauncher"
        ];
      };
    };

    # TODO
    xdg.dataFile."PrismLauncher/themes/theme.json".text = ''
      {
          "colors": {
              "AlternateBase": "#1e1e2e",
              "Base": "#181825",
              "BrightText": "#bac2de",
              "Button": "#313244",
              "ButtonText": "#cdd6f4",
              "Highlight": "#b4befe",
              "HighlightedText": "#1e1e2e",
              "Link": "#b4befe",
              "Text": "#cdd6f4",
              "ToolTipBase": "#dee5fc",
              "ToolTipText": "#dee5fc",
              "Window": "#1e1e2e",
              "WindowText": "#bac2de",
              "fadeAmount": 0.5,
              "fadeColor": "#6c7086"
          },
          "name": "Catppuccin Mocha",
          "widgets": "Fusion"
      }
    '';

    xdg.dataFile."PrismLauncher/themes/themeStyle.css".text = ''
      QToolTip {
          color: #cdd6f4;
          background-color: #313244;
          border: 1px solid #313244
      }%
    '';
  };
}
