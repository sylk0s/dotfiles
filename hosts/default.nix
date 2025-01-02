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
    # inputs.nur.nixosModules.nur
  ];

  nixpkgs.config.allowUnfree = mkDefault true;

  #environment.variables.DOTFILES = config.dotfiles.dir;
  #environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # TODO
  nix = let
    # filteredInputs = filterAttrs (n: _: n != "self") inputs;
    # nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    # registryInputs = mapAttrs (_: v: {flake = v;}) filteredInputs;
  in {
    # package = pkgs.nixFlakes;

    # nixPath = nixPathInputs ++ ["dotfiles=${config.dotfiles.dir}"];

    # registry = registryInputs // {dotfiles.flake = inputs.self;};

    settings = {
      experimental-features = mkDefault "nix-command flakes";
      auto-optimise-store = mkDefault true;
      # TODO think of a way to make this nicer
      trusted-users = ["sylkos"];
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    # overlays = [
    #   (import ./grub_overlay.nix)
    # ];
    hostPlatform.system = "x86_64-linux";
  };

  # TODO what is this
  # system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs;
    mkDefault [
      git
      neovim
      curl
    ];
}
