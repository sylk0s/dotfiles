# Colors based on Xresources
{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf isNull;
  inherit (sylib) mk-enable;

  colorType = lib.types.addCheck lib.types.str (x: !isNull (builtins.match "#[0-9a-fA-F]{6}" x));
  color = defaultColor:
    lib.mkOption {
      type = colorType;
      default = defaultColor;
    };
  cfg = config.modules.themes.colors;
in {
  options.modules.themes.colors = {
    enable = mk-enable true;

    # TODO replace this later
    # cattpuccin
    colors = {
      color0 = color "#45475A";
      color1 = color "#f38ba8";
      color2 = color "#a6e3a1";
      color3 = color "#f9e2af";
      color4 = color "#89b4fa";
      color5 = color "#f5c2e7";
      color6 = color "#94e2d5";
      color7 = color "#bac2de";
      color8 = color "#585b70";
      color9 = color "#f38ba8";
      color10 = color "#a6e3a1";
      color11 = color "#f9e2af";
      color12 = color "#89b4fa";
      color13 = color "#f5c2e7";
      color14 = color "#94e2d5";
      color15 = color "#a6adc8";
    };
    types = {
      background = color "#1e1e2e";
      background-darker = color "#11111b";
      foreground = color "#cdd6f4";
      highlight = color "#f78166"; # not cat
      border = color "#30363d"; # not cat
      #selection = color "#2d3139";
      #current-line = color "#171b22";
    };
    syntax = {
      #comment = color "#8b949e";
      #keyword = color "#ff7b72";
      #function = color "#d2a8ff";
      #variable = color "#ffa657";
      #string = color "#a5d6ff";
      #label = color "#79c0ff";
    };
    diagnostic = {
      #error = color "#f85149";
      #warning = color "#f0883e";
    };
  };
}
