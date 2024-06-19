mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt &&
mkdir /mnt/home &&
mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home &&
mkdir /mnt/nix &&
mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix &&
mkdir /mnt/persist &&
mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist &&
mkdir -p /mnt/var/log &&
mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log &&

mount /dev/sdb1 /mnt/boot &&

swapon /dev/root_vg/swap_v
