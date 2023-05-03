{ config, lib, pkgs, user, ... }:

{
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord
    htop
    eww-wayland
    pavucontrol
    vscodium
    neofetch
    wofi
    firefox
    gh
  ];
}
