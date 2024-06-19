vgcreate root_vg /dev/mapper/crypt &&
lvcreate -n swap_v -L 16G root_vg &&
lvcreate -n root_v -l +100%FREE root_vg
