# This file contains all of the things I want to be on every system.
{
  inputs,
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Import the home-manager module and all my custom modules
  imports = [
    ../users # user definitions
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = mkDefault true;

  #environment.variables.DOTFILES = config.dotfiles.dir;

  # TODO
  nix = {
    settings = {
      experimental-features = mkDefault "nix-command flakes";
      auto-optimise-store = mkDefault true;
      # TODO think of a way to make this nicer
      trusted-users = ["sylkos"];
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://catppuccin.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      ];
    };
  };

  nixpkgs = {
    hostPlatform.system = "x86_64-linux";
    overlays = [
      inputs.nix-xilinx.overlay
    ];
  };

  # TODO should this be system wide or nah
  system.stateVersion = "21.05";

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs;
    mkDefault [
      vivado
      git
      neovim
      curl
    ];

  boot.kernelPackages = mkDefault pkgs.linuxPackages_latest;
}
