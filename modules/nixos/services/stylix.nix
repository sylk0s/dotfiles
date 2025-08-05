{
  config,
  lib,
  sylib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.services.stylix;
in {
  imports = [ inputs.stylix.nixosModules.stylix ];
  options.sylk.services.stylix = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };
  };
}
