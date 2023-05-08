{ pkgs, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
#		./nvidia.nix
  ];

	#boot.kernelParams = [ "nomodeset" ];

	#services.xserver.desktopManager.gnome.enable = true;

  modules = {
    desktop = {
      hyprland = {
				enable = true;
#				nvidia = true;
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
			};
    };
		dev = {
			python.enable = true;
		};
		hardware = {
			audio.enable = false;
		};
  };

	# TODO remove all of these :3
	environment.systemPackages = with pkgs; [
		pciutils
		libva
		libsForQt5.qt5ct
		mesa
		brightnessctl
		networkmanagerapplet
	];

	nixpkgs.config.packageOverrides = pkgs: rec {
		wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
			patches = attrs.patches ++ [ ./eduroam.patch ];
		});
	};

  # TODO CPU?
	# TODO auto gpu switching

  networking.networkmanager.enable = true;
	
	# WPA_SUPPLICANT
	#networking.wireless.enable = true;
	#users.extraUsers.sylkos.extraGroups = [ "wheel" ];
	#networking.wireless.userControlled.enable = true;

	#networking.wireless.environmentFile = "/home/sylkos/wireless.env";
	#networking.wireless.networks = {
  #eduroam.auth = ''
	#	key_mgmt=WPA-EAP
  #  eap=PWD
  #  identity="@USER@"
  #  password="@PASS@"
  #'';
#};
}

