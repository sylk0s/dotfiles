{...}: {
  boot.supportedFilesystems = ["btrfs"];
  fileSystems."/var/log" = {
    neededForBoot = true;
  };

  fileSystems.AAA = {
    options = ["subvol=NAMEHERE" "compress=zstd" "noatime"];
  };

  swapDevices = [{device = "/swap/swapfile";}];
}
