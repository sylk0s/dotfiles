{
  description = "Sylkos's NixOS configuration";

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

    lanzaboote.url = "github:nix-community/lanzaboote";

    hyprpanel = {
      url = "github:jas-singhfsu/hyprpanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
    sylib = import ./lib {inherit lib inputs;};
    module-paths = sylib.all-modules-in-dir-rec ./modules/nixos;
  in {
    lib = lib;

    sylib = sylib;

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

