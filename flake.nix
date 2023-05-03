{
  description = "Sylkos's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs @ { self, nixpkgs, hyprland, home-manager, ... }: 

    # Variables for use throughout the rest of the config
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
	config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # testing setup (extra hard drive on pc)
	nix = lib.nixosSystem {
	  inherit system;

          modules = [ 
            ./configuration.nix 

            hyprland.nixosModules.default
            {programs.hyprland.enable = true;}

	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.sylkos = {
		imports = [
		  ./home.nix
		];
	      };
	    }
          ];
	};
      };
    };
}

