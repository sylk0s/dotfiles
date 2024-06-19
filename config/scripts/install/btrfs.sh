sudo mkfs.btrfs /dev/root_vg/root_v -L test
sudo mount -t btrfs /dev/root_vg/root_v /mnt

sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/log

sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

sudo umount /mnt

sudo mount -o subvol=root,compress=zstd /dev/root_vg/root_v /mnt
sudo mkdir /mnt/home
sudo mount -o subvol=home,compress=zstd /dev/root_vg/root_v /mnt/home
sudo mkdir /mnt/nix
sudo mount -o subvol=nix,compress=zstd,noatime /dev/root_vg/root_v /mnt/nix
sudo mkdir /mnt/persist
sudo mount -o subvol=persist,compress=zstd /dev/root_vg/root_v /mnt/persist
sudo mkdir -p /mnt/var/log
sudo mount -o subvol=log,compress=zstd /dev/root_vg/root_v /mnt/var/log