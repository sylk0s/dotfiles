{
  description = "Sylkos's NixOS configuration";

  inputs = {
    # default nix pkgs repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # stable nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    # home-manager import
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland related stuffs
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # hardware specific configs
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ephemeral filesystem
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secret management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # theming
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = { 
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-awesome-neovim-plugins = {
      url = "github:m15a/flake-awesome-neovim-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-xilinx = {
      url = "github:MIT-OpenCompute/xilinx-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-awesome-neovim-plugins,
    ...
  }: let
    inherit (nixpkgs) lib;
    sylib = import ./lib {inherit lib inputs;};
    module-paths = sylib.all-modules-in-dir-rec ./modules/nixos;

  in {
    inherit lib sylib;

    # Custom pkgs
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for nix files
    # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom overlays
    # overlays = mapModules ./overlays import;

    # Exports all of the modules from this flake
    # nixosModules = {...}: {imports = module-paths;};

    # Exports all of the modules from home-manager
    # homeManagerModules = {...}: {imports = outputs.sylib.all-modules-in-dir-rec ./modules/home-manager;};

    # Imports the hosts from the default.nix in each folder of ./hosts
    nixosConfigurations =
      sylib.mk-hosts {
        inherit inputs sylib;
      }
      module-paths
      ./hosts;

    # homeManagerConfiguration = mapHmConfigs ./hosts;
  };
}
#a
#a

