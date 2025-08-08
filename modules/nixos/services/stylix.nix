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

  julia-mono-nerd-font = pkgs.callPackage "${inputs.self.outPath}/pkgs/julia-mono-nerd-font.nix" {inherit pkgs;};
in {
  imports = [ inputs.stylix.nixosModules.stylix ];
  options.sylk.services.stylix = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = {
        sansSerif = {
          package = julia-mono-nerd-font;
          name = "JuliaMono Nerd Font Mono";
        };
        monospace = {
          package = julia-mono-nerd-font;
          name = "JuliaMono Nerd Font Mono";
        };
        serif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          desktop = 11;
          applications = 11;
          terminal = 11;
        };
      };
    };
  };
}
