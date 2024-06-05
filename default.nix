# This file contains all of the things I want to be on every system.
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  imports =
    [inputs.home-manager.nixosModules.home-manager]
    # all personally defined modules imported here
    ++ (mapModulesRec (toString ./modules) import);

  nixpkgs.config.allowUnfree = true;

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # TODO
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: {flake = v;}) filteredInputs;
  in {
    package = pkgs.nixFlakes;

    nixPath = nixPathInputs ++ ["dotfiles=${config.dotfiles.dir}"];

    registry = registryInputs // {dotfiles.flake = inputs.self;};

    settings = {
      # also some options here about keys, subscribers, cachix
      experimental-features = "nix-command flakes";
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      auto-optimise-store = true;
    };
  };

  # TODO
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = mkDefault 10;
      };

      timeout = null;
    };
  };

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    neovim
    curl
    pciutils
  ];
}
