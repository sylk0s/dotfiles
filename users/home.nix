# Default home-manager config for each user's home
{
  inputs,
  lib,
  outputs,
  ...
}:
with lib.sylkos; {
  imports = mapModulesRec ../modules/home-manager import;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home = {
    stateVersion = lib.mkDefault "21.05";
    #sessionPath = ["$HOME/.local/bin"];
    # sessionVariables = {
    #   FLAKE = "$HOME/Documents/NixConfig";
    # };
  };
}
