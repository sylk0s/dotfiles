sudo mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt
sudo mkdir /mnt/home
sudo mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home
sudo mkdir /mnt/nix
sudo mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix
sudo mkdir /mnt/persist
sudo mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist
sudo mkdir -p /mnt/var/log
sudo mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log

sudo mount /dev/sdb1 /mnt/boot

sudo swapon /dev/root_vg/swap_v