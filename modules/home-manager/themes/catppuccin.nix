{
  config,
  options,
  lib,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.themes.catppuccin;
in {
  options.modules.themes.catppuccin = {
    enabled = mkBoolOpt true;
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  config = mkIf cfg.enabled {
    #   # assertations = [
    #   #   {
    #   #     assertion = true;
    #   #     message = "";
    #   #   }
    #   #   # ...
    #   # ];

    #   # callback

    catppuccin = {
      enable = true;
      accent = "lavender";
      flavor = "mocha";
    };

    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        accent = "lavender";
        flavor = "mocha";
        cursor = {
          enable = true;
          accent = "lavender";
          flavor = "mocha";
        };
        icon = {
          enable = true;
          accent = "lavender";
          flavor = "mocha";
        };
      };
    };
  };
}
