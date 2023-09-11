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
				steam.enable = true;
				mc.enable = true;
				emu.enable = true;
			};
			services = {
				eww = {
					enable = true;
					#layout = "rightbar";
				};
				docker.enable = true;
			};
    };
		dev = {
			python.enable = true;
			rust.enable = true;
			julia.enable = true;
			java.enable = true;
			c.enable = true;
		};
		hardware = {
			audio.enable = true;
		};
  };

	# TODO remove all of these :3
	environment.systemPackages = with pkgs; [
		# I don't remember what these are for
		libva
		libsForQt5.qt5ct

		mesa
		
		# laptopy things
		brightnessctl
		acpi
	
		# random
		networkmanagerapplet
		openssl
		vscode
		wireshark
		cura
		quartus-prime-lite
	];

#	nixpkgs.config.packageOverrides = pkgs: rec {
#		wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
#			patches = attrs.patches ++ [ ./eduroam.patch ];
#		});
#	};

  # TODO CPU?
	# TODO auto gpu switching

  networking.networkmanager.enable = true;
	
	# trying IWD to see if it works better with eduroam/WPA Enterprise
	networking.wireless.iwd.enable = true;
	networking.networkmanager.wifi.backend = "iwd";
	
#	nmcli connection add \
#		type wifi con-name "MySSID" ifname wlp0s20f3 ssid "MySSID" -- \
#		wifi-sec.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity "USERNAME" \
#		 THERE WAS ALSO SOMETHING HERE BUT I FORGOT IT BUT IWD PROMPTS YOU TO ADD IT SO...
#		802-1x.private-key-password "..." 802-1x.phase2-auth mschapv2

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

	hardware.bluetooth.enable = true;
	services.blueman.enable = true;

	# temp timezone changer
	# time.timeZone = "Europe/Budapest";
}
