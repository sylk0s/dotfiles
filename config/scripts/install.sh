# these set everything up

./install/luks.sh
./install/lvm.sh
./install/btrfs.sh
./install/boot.sh
./install/swap.sh

# generate the hardware-nix

sudo nixos-generate-config --root /mnt