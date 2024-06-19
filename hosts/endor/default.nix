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

    services = {
      docker.enable = true;
      gpg.enable = true;
      sops.enable = true;
      # virtualbox.enable = true;
    };

    users = [
      {
        name = "sylkos";
        priviledged = true;
        config = "${config.dotfiles.dir}/users/sylkos";
      }
    ];
  };

  # TODO remove all of these :3
  environment.systemPackages = with pkgs; [
    # laptopy things
    acpi

    # engineering bullshit apps
    # cura
    # kicad

    # removed in favor of:
    # https://codeberg.org/tropf/nix-inkstitch
    #inkscape-with-extensions
    #python311Packages.pygobject3

    #jetbrains.clion

    # libsodium
    sshfs
  ];

  services = {
    gnome.gnome-keyring.enable = true;
  };

  #   nmcli connection add \
  #       type wifi con-name "MySSID" ifname wlp0s20f3 ssid "MySSID" -- \
  #       wifi-sec.key-mgmt wpa-eap 802-1x.eap peap 802-1x.identity "USERNAME" \
  #        THERE WAS ALSO SOMETHING HERE BUT I FORGOT IT BUT IWD PROMPTS YOU TO ADD IT SO...
  #       802-1x.private-key-password "..." 802-1x.phase2-auth mschapv2

  # time.timeZone = "Europe/Budapest";

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
