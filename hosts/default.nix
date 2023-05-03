{ lib, inputs, nixpkgs, home-manager, user, hyprland, ... }:

let
  system = "x86_64-linux";

  pkgs = {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  testing = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs user hyprland system;
      host = {
        hostName = "testing";
	# TODO
	# mainMonitor = "DP-1"

      };
    };

    modules = [
      hyprland.nixosModules.default

      ./configuration.nix
      ./testing

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	
	home-manager.users.${user} = {
          imports = [
	    ./home.nix
	  ]
	}
      }
    ];
  }
}
