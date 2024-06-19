mkfs.vfat -F 32 -n NIXBOOT /dev/nvme0n1p1 &&
mkdir /mnt/boot &&
mount /dev/nvme0n1p1 /mnt/boot
