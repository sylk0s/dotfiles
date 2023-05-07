{ pkgs, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

	boot.kernelParams = [ "nomodeset" ];

  modules = {
    desktop = {
      hyprland = {
				enable = true;
				nvidia = true;
			};
      media.spotify.enable = true;
      social = {
      	discord.enable = true;
      	signal.enable = true;
      };
			apps = {
				firefox.enable = true;
				intellij.enable = true;
			};
			gaming = {
				#steam.enable = true;
			};
			services = {
				eww.enable = true;
				eww.package = pkgs.eww; # this is set because the default is eww-wayland
			};
    };
		dev = {
			python.enable = true;
		};
  };

	# TODO remove all of these :3
	environment.systemPackages = with pkgs; [

	];

  # TODO CPU?
	# TODO auto gpu switching

  networking.networkmanager.enable = true;
}

