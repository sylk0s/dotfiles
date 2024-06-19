sudo cryptsetup luksFormat /dev/sdb2 --label test_fs
sudo cryptsetup luksOpen /dev/sdb2 test_crypt