{
  description = "Sylkos's NixOS configuration";

  # these only affect this flake, not the whole system
  # adds the additional cachix repo so we don't have to build from scratch
  # nixConfig = {
  #   extra-substituters = ["https://cosmic.cachix.org/" "https://hyprland.cachix.org"];
  #   extra-trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  # };

  inputs = {
    # default nix pkgs repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager import
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland related stuffs
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # ags for wayland bar/widets
    ags.url = "github:Aylur/ags";

    # hardware specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # declaritive hyprland
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ephemeral filesystem
    impermanence.url = "github:nix-community/impermanence";

    # secret management
    sops-nix.url = "github:Mic92/sops-nix";

    # theming
    catppuccin.url = "github:catppuccin/nix";

    # cosmic desktop
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
  in {
    lib = lib;

    sylib = import ./lib {inherit lib inputs;};

    # Custom pkgs
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for nix files
    # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom overlays
    # overlays = mapModules ./overlays import;

    # Exports all of the modules from this flake
    nixosModules = {...}: {imports = outputs.sylib.mapModulesRec ./modules/nixos;};

    # Exports all of the modules from home-manager
    homeManagerModules = {...}: {imports = outputs.sylib.mapModulesRec ./modules/home-manager;};

    # Imports the hosts from the default.nix in each folder of ./hosts
    nixosConfigurations = (({...}: {a = outputs.sylib.mapHosts ./hosts;}) {inherit self inputs outputs lib;}).a;

    # homeManagerConfiguration = mapHmConfigs ./hosts;
  };
}
