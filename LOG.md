this is a log for everything im doing to make this work

- boot into gnome iso
- connect to the internet (this is why i like gnome iso... it's easy)

- check the drive setup PLS to make sure it's sda or sdb...
```
// luks
# sudo cryptsetup luksFormat /dev/sdb2 --label test_fs
# sudo cryptsetup luksOpen /dev/sdb2 test_crypt


// LVM
# sudo vgcreate root_vg /dev/mapper/test_crypt
# sudo lvcreate -n swap_v -L 16G root_vg
# sudo lvcreate -n root_v -l +100%FREE root_vg


// btrfs
# sudo mkfs.btrfs /dev/root_vg/root_v -L test
# sudo mount -t btrfs /dev/root_vg/root_v /mnt

# sudo btrfs subvolume create /mnt/root
# sudo btrfs subvolume create /mnt/home
# sudo btrfs subvolume create /mnt/nix
# sudo btrfs subvolume create /mnt/persist
# sudo btrfs subvolume create /mnt/log

# sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# sudo umount /mnt

# sudo mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt
# sudo mkdir /mnt/home
# sudo mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home
# sudo mkdir /mnt/nix
# sudo mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix
# sudo mkdir /mnt/persist
# sudo mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist
# sudo mkdir -p /mnt/var/log
# sudo mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log


// boot partition
# sudo mkfs.vfat -F 32 -n NIXBOOT /dev/sdb1
# sudo mkdir /mnt/boot
# sudo mount /dev/sdb1 /mnt/boot


// swap file
# sudo mkswap /dev/root_vg/swap_v
# sudo swapon /dev/root_vg/swap_v


# sudo nixos-generate-config --root /mnt


# sudo vim /mnt/etc/nixos/hardware-configuration.nix
- added compression to each filesystems."path".options
- added neededForBoot to log and persist

// copy the premade configuration.nix
# sudo rm /mnt/etc/nixos/configuration.nix
# sudo cp dotfiles/tmp/configuration.nix /mnt/etc/nixos/


$ cd /mnt
# sudo nixos-install

- reboot
```

## note for labels:
${hostname}_fs = name of luks encrypted volume
${hostname}_crypt = name in /dev/mapper of this volume
${hostname} = name of btrfs filesystem volume
root_v = root logical volume
swap_v = swap logical volume