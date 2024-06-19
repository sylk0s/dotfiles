mkfs.vfat -F 32 -n NIXBOOT /dev/sdb1 &&
mkdir /mnt/boot &&
mount /dev/sdb1 /mnt/boot