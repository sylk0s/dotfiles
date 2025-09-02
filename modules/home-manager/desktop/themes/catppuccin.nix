{
  config,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (sylib) mk-enable;

  cfg = config.sylk.themes.catppuccin;
in {
  options.sylk.themes.catppuccin = {
    enable = mk-enable false;
    cursors.enable = mk-enable true;
    icons.enable = mk-enable true;
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  config = mkMerge [(mkIf cfg.enable {
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
  })
  (mkIf (cfg.enable || cfg.cursors.enable) {
      catppuccin.cursors = {
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
   }
  )
  (mkIf (cfg.enable || cfg.icons.enable) {
    catppuccin.gtk.icon = {
      enable = true;
      flavor = "mocha";
      accent = "lavender";
    };
  })];
}
