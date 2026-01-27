{
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.desktop.gaming.olympus;
in {
  options.sylk.desktop.gaming.olympus = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        olympus
      ];

      persistence."/persist" = {
        directories = [
          # TODO something goes here meow
        ];
      };
    };
  };
}
