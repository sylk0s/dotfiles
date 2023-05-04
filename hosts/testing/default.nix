{ pkgs, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      hyprland.enable = true;
    }
  }

  # TODO CPU?

  networking.networkmanager.enable = true;
}
