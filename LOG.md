this is a log for everything im doing to make this work

- boot into gnome iso
- connect to the internet (this is why i like gnome iso... it's easy)

```
# cryptsetup luksFormat /dev/sda2
# cryptsetup luksOpen /dev/sda2 test_crypt
# mkfs.btrfs /dev/mapper/test_crypt
# mount -t btrfs /dev/mapper/test_crypt /mnt

# btrfs subvolume create /mnt/root
# btrfs subvolume create /mnt/home
# btrfs subvolume create /mnt/nix
# btrfs subvolume create /mnt/persist
# btrfs subvolume create /mnt/log
# btrfs subvolume create /mnt/swap

# btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# umount /mnt

# mount -o subvol=root,compress=zstd,noatime /dev/mapper/test_crypt /mnt
# mkdir /mnt/home
# mount -o subvol=home,compress=zstd,noatime /dev/mapper/test_crypt /mnt/home
# mkdir /mnt/nix
# mount -o subvol=nix,compress=zstd,noatime /dev/mapper/test_crypt /mnt/nix
# mkdir /mnt/persist
# mount -o subvol=persist,compress=zstd,noatime /dev/mapper/test_crypt /mnt/persist
# mkdir -p /mnt/var/log
# mount -o subvol=log,compress=zstd,noatime /dev/mapper/test_crypt /mnt/var/log

# mkdir /swap
# mount -o subvol=swap /dev/mapper/test_crypt /swap
see btrfs.readthedocs.io/en/latest/Swapfile.html for mroe info about why below is broken
# btrfs filesystem mkswapfile --size=8g --uuid clear /swap/swapfile

# mkfs.vfat -n BOOT /dev/sda1
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot

# nixos-generate-config --root /mnt

# vim /mnt/etc/nixos/hardware-configuration.nix
- added compression to each filesystems."path".options
- added boot.supportedFilesystems
- added neededForBoot to log
- added swap

# TODO the ephemerality part

# vim /mnt/etc/nixos/configuration.nix
- changed user to sylkos
- enabled git and vim for user
- removed gnome
- enabled network-manager
- enabled locale
- enabled keyboard layout

# TODO add labels to hardware config

# cd /mnt
# nixos-install
- reboot
```