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
    desktop = {
      hyprland = {
        enable = true;
      };
      media.spotify.enable = true;
      social = {
        discord.enable = true;
        signal.enable = true;
      };
      apps = {
        firefox = {
          enable = true;
          profileName = "ahpu6nkm";
        };
        intellij.enable = true;
        virtualbox.enable = false;
      };
      security = {
        cutter.enable = false;
        wireshark.enable = true;
        ghidra.enable = true;
        burpsuite.enable = true;
      };
      gaming = {
        steam.enable = true;
        mc.enable = true;
        emu.enable = false;
      };
      services = {
        ags = {
          enable = true;
        };
        docker.enable = true;
        dunst.enable = false;
        agenix.enable = false;
      };
    };
    dev = {
      python.enable = true;
      rust.enable = true;
      julia.enable = true;
      java.enable = true;
      c.enable = true;
      matlab.enable = false;
      racket.enable = true;
      haskell.enable = true;
      embedded.enable = true;
    };

    shell = {
      eza.enable = true;
    };

    audio.enable = true;
    bluetooth.enable = true;
    network.enable = true;
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

  # idk if I need these still
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE:="0666", SYMLINK+="stlinkv1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374a", MODE:="0666", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE:="0666", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE:="0666", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0666", SYMLINK+="stlinkv2_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE:="0666", SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", MODE:="0666", SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", MODE:="0666", SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", MODE:="0666", SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE:="0666", SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", MODE:="0666", SYMLINK+="stlinkv3_%n"
  '';

  # find arch :3
  boot.loader.grub.extraEntries = ''
    menuentry "Arch Linux (on /dev/nvme1n1p7)" --class arch --class os {
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 0037-42F6
        echo 'Loading Arch Linux'
        linux /vmlinuz-linux root=/dev/mapper/vg0-root rw cryptdevice=/dev/nvme1n1p7:cryptlvm root=/dev/vg0/root loglevel=3 quiet
        echo 'Loading initial ramdisk ...'
        initrd /initramfs-linux.img
    }
  '';
}
