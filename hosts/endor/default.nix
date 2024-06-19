{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9520
  ];

  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;

    impermanence.enable = true;
    services = {
      #docker.enable = true;
      gpg.enable = true;
      #sops.enable = true;
      # virtualbox.enable = true;
    };

    users = [
      {
        name = "sylkos";
        priviledged = true;
        config = "${config.dotfiles.dir}/users/test";
      }
    ];
  };

	boot = {
	    initrd = {
	      luks.devices = {
		"crypt" = {
		  device = "/dev/disk/by-uuid/998f2dd7-0a0a-41c2-b8b5-fdcb957f7b87";
		  preLVM = true;
		};
	      };
	    };
	  };

  home-manager.backupFileExtension = "backup";

  # find arch :3
  boot.loader.grub.extraEntries = ''
    menuentry "Arch Linux (on /dev/nvme1n1p7)" --class arch --class os {
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 0037-42F6
        echo ""
        echo ""
        echo ""
        echo 'Loading Arch Linux'
        linux /vmlinuz-linux root=/dev/mapper/vg0-root rw cryptdevice=/dev/nvme1n1p7:cryptlvm root=/dev/vg0/root loglevel=3 quiet
        echo 'Loading initial ramdisk ...'
        initrd /initramfs-linux.img
    }
  '';
}
