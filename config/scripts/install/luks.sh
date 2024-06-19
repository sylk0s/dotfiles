cryptsetup luksFormat /dev/sdb2 --label test_fs &&
cryptsetup luksOpen /dev/sdb2 test_crypt
