{ pkgs, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      hyprland.enable = true;
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
			};
			services = {
				eww.enable = true;
				docker.enable = true;
			};
    };
		dev = {
			python.enable = true;
			rust.enable = true;
			julia.enable = true;
		};
  };

	# TODO remove all of these :3
	environment.systemPackages = with pkgs; [
		#pavucontrol	
	];

  # TODO CPU?

  # needed on this machine to get the GDM login thingy to appear on the right screen
  systemd.tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
	<monitors version="2">
	  <configuration>
	    <logicalmonitor>
	      <x>1920</x>
	      <y>0</y>
	      <scale>1</scale>
	      <transform>
		<rotation>right</rotation>
		<flipped>no</flipped>
	      </transform>
	      <monitor>
		<monitorspec>
		  <connector>HDMI-1</connector>
		  <vendor>HWP</vendor>
		  <product>HP LP2475w</product>
		  <serial>CNC0090CVH</serial>
		</monitorspec>
		<mode>
		  <width>1920</width>
		  <height>1200</height>
		  <rate>59.950</rate>
		</mode>
	      </monitor>
	    </logicalmonitor>
	    <logicalmonitor>
	      <x>0</x>
	      <y>340</y>
	      <scale>1</scale>
	      <primary>yes</primary>
	      <monitor>
		<monitorspec>
		  <connector>DP-1</connector>
		  <vendor>LEN</vendor>
		  <product>LEN T2424zA</product>
		  <serial>V1K90974</serial>
		</monitorspec>
		<mode>
		  <width>1920</width>
		  <height>1080</height>
		  <rate>60.000</rate>
		</mode>
	      </monitor>
	    </logicalmonitor>
	  </configuration>
	</monitors>
      ''}"
  ];

  networking.networkmanager.enable = true;
}

