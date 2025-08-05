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

  cfg = config.sylk.themes.catppuccin;
in {
  options.sylk.themes.catppuccin = {
    enable = mk-enable true;
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  config = mkIf cfg.enable {
    #   # assertions = [
    #   #   {
    #   #     assertion = true;
    #   #     message = "";
    #   #   }
    #   #   # ...
    #   # ];

    #   # callback
    gtk.enable = true;

    catppuccin = {
      enable = true;
      accent = "lavender";
      flavor = "mocha";
      cursors = {
        enable = true;
        accent = "lavender";
        flavor = "mocha";
      };
      #gtk = {
      #  enable = true;
      #  accent = "lavender";
      #   flavor = "mocha";
      #   icon = {
      #     enable = true;
      #     accent = "lavender";
      #     flavor = "mocha";
      #   };
      # };
    };
  };
}
