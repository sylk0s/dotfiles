sudo vgcreate root_vg /dev/mapper/test_crypt
sudo lvcreate -n swap_v -L 16G root_vg
sudo lvcreate -n root_v -l +100%FREE root_vg