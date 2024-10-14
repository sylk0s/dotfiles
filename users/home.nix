# Default home-manager config for each user's home
{lib, ...}: let
  inherit (lib) mkDefault;
in {
  programs.home-manager.enable = mkDefault true;
  programs.git.enable = mkDefault true;

  nixpkgs.config.allowUnfree = mkDefault true;

  home = {
    stateVersion = mkDefault "21.05";
    #   sessionPath = ["$HOME/.local/bin"];
    #   sessionVariables = {
    #     FLAKE = "$HOME/Documents/NixConfig";
    #   };
  };
}
