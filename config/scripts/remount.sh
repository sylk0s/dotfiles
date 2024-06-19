cryptsetup luksOpen /dev/sdb2 test_crypt &&

mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt &&
mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home &&
mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix &&
mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist &&
mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log &&

mount /dev/sdb1 /mnt/boot &&

swapon /dev/root_vg/swap_v
