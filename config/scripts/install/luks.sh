cryptsetup luksFormat /dev/nvme0n1p2 --label fs &&
cryptsetup luksOpen /dev/nvme0n1p2 crypt
