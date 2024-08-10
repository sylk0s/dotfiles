# This file contains all of the things I want to be on every system.
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # Import the home-manager module and all my custom modules
  imports =
    [
      ../users # user definitions
      inputs.home-manager.nixosModules.home-manager
      # inputs.nur.nixosModules.nur
    ]
    ++ outputs.nixosModules; # imports all nixos modules

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
      substituters = ["https://cosmic.cachix.org/" "https://hyprland.cachix.org"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  # TODO what is this
  # system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.05";

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = mkDefault "/boot";
      };

      grub = {
        enable = mkDefault true;
        devices = ["nodev"];
        efiSupport = mkDefault true;
        useOSProber = mkDefault true;
        configurationLimit = mkDefault 10;
        copyKernels = mkDefault true; # TODO make this dependent on encryption maybe
      };

      timeout = mkDefault null;
    };
  };

  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  environment.systemPackages = with pkgs;
    mkDefault [
      git
      neovim
      curl
    ];
}
