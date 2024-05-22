{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:Aylur/ags";

    agenix.url = "github:ryantm/agenix";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    hyprland-plugins,
    nix-matlab,
    agenix,
    nixos-hardware,
    ...
  }: let
    inherit (lib.my) mapModules mapModulesRec mapHosts;

    system = "x86_64-linux";

    mkPkgs = pkgs: extraOverlays:
      import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlay = extraOverlays;
      };

    pkgs = mkPkgs nixpkgs [];

    lib =
      nixpkgs.lib.extend
      (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
  in {
    lib = lib.my;

    # overlay = final: prev: {
    #   unstable = pkgs';
    #   my = self.packages."${system}";
    # };

    overlays =
      mapModules ./overlays import;

    # Imports all of the modules in ./modules?
    nixosModules =
      {
        # imports default.nix from this directory
        dotfiles = import ./.;
      }
      // mapModulesRec ./modules import;

    # Imports the hosts from the default.nix in each folder of ./hosts
    nixosConfigurations = mapHosts ./hosts {};

    #nixosConfigurations.testing = inputs.nixpkgs.lib.nixosSystem {
    #  specialArgs = {inherit inputs;};
    #  modules = [
    #    ./configuration.nix
    #  ];
    #};
  };
}
