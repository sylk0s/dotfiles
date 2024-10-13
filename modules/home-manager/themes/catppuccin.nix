{
  config,
  options,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.modules.themes.catppuccin;
in {
  options.modules.themes.catppuccin = {
    enabled = mk-enable true;
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  config = mkIf cfg.enabled {
    #   # assertions = [
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
