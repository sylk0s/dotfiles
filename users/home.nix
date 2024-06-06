# Default home-manager config for each user's home
{
  inputs,
  lib,
  outputs,
  osConfig,
  ...
}:
with lib.sylkos; {
  #imports = mapModulesRec ../modules/home-manager import;
  imports = outputs.homeManagerModules;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = lib.mkDefault "21.05";
    #   sessionPath = ["$HOME/.local/bin"];
    #   sessionVariables = {
    #     FLAKE = "$HOME/Documents/NixConfig";
    #   };
  };
}
