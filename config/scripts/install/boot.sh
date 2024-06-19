sudo mkfs.vfat -F 32 -n NIXBOOT /dev/sdb1
sudo mkdir /mnt/boot
sudo mount /dev/sdb1 /mnt/boot