mkfs.btrfs /dev/root_vg/root_v -L test &&
mount -t btrfs /dev/root_vg/root_v /mnt &&

btrfs subvolume create /mnt/root &&
btrfs subvolume create /mnt/home &&
btrfs subvolume create /mnt/nix &&
btrfs subvolume create /mnt/persist &&
btrfs subvolume create /mnt/log &&

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank &&

umount /mnt &&

mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt &&
mkdir /mnt/home &&
mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home &&
mkdir /mnt/nix &&
mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix &&
mkdir /mnt/persist &&
mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist &&
mkdir -p /mnt/var/log &&
mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log
