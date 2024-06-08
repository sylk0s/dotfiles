this is a log for everything im doing to make this work

- boot into gnome iso
- connect to the internet (this is why i like gnome iso... it's easy)

```
# sudo cryptsetup luksFormat /dev/sda2 --label test_fs
# sudo cryptsetup luksOpen /dev/sda2 test_crypt
# sudo mkfs.btrfs /dev/mapper/test_crypt -L test
# sudo mount -t btrfs /dev/disk/by-label/test_fs /mnt

note for labels:
${hostname}_fs = name of luks encrypted volume
${hostname}_crypt = name in /dev/mapper of this volume
${hostname} = name of btrfs filesystem volume

# sudo btrfs subvolume create /mnt/root
# sudo btrfs subvolume create /mnt/home
# sudo btrfs subvolume create /mnt/nix
# sudo btrfs subvolume create /mnt/persist
# sudo btrfs subvolume create /mnt/log
# sudo btrfs subvolume create /mnt/swap

# sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# sudo umount /mnt

# sudo mount -o subvol=root,compress=zstd,noatime /dev/disk/by-label/test_fs /mnt
# sudo mkdir /mnt/home
# sudo mount -o subvol=home,compress=zstd,noatime /dev/disk/by-label/test_fs /mnt/home
# sudo mkdir /mnt/nix
# sudo mount -o subvol=nix,compress=zstd,noatime /dev/disk/by-label/test_fs /mnt/nix
# sudo mkdir /mnt/persist
# sudo mount -o subvol=persist,compress=zstd,noatime /dev/disk/by-label/test_fs /mnt/persist
# sudo mkdir -p /mnt/var/log
# sudo mount -o subvol=log,compress=zstd,noatime /dev/disk/by-label/test_fs /mnt/var/log

# sudo mkdir /swap
# sudo mount -o subvol=swap /dev/disk/by-label/test_fs /swap
# sudo truncate -s 0 /swap/swapfile
# sudo chattr +C /swap/swapfile
# sudo fallocate -l 4G /swap/swapfile
# sudo chmod 0600 /swap/swapfile
# sudo mkswap /swap/swapfile
see btrfs.readthedocs.io/en/latest/Swapfile.html for mroe info about why below is broken
// this shouls work but doesn't# btrfs filesystem mkswapfile --size=8g --uuid clear /swap/swapfile

# sudo mkfs.fat -F 32 -n NIXBOOT /dev/sda1
# sudo mkdir /mnt/boot
# sudo mount /dev/sda1 /mnt/boot

# sudo nixos-generate-config --root /mnt

# sudo vim /mnt/etc/nixos/hardware-configuration.nix
- added compression to each filesystems."path".options
- added boot.supportedFilesystems
- added neededForBoot to log
- added swap

# TODO the ephemerality part

# sudo vim /mnt/etc/nixos/configuration.nix
- changed user to sylkos
- enabled git and vim for user
- removed gnome
- enabled network-manager
- enabled locale
- enabled keyboard layout

# TODO add labels to hardware config

$ cd /mnt
# sudo nixos-install

- reboot
```