{
  config,
  options,
  lib,
  inputs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.impermanence = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    boot.initrd.postDeviceCommands = mkAfter ''
      mkdir /btrfs_tmp
      mount -t btrfs /dev/root_vg/root_v /btrfs_tmp

      echo "deleting root recursively" &&
      btrfs subvolume list -o /btrfs_tmp/root |
      cut -f9 -d ' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/btrfs_tmp/$subvolume"
      done &&
      echo "deleting /root subvolume" &&
      btrfs subvolume delete /btrfs_tmp/root &&
      echo "restoring blank snapshot" &&
      btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/root

      echo "deleting home recursively" &&
      btrfs subvolume list -o /btrfs_tmp/home |
      cut -f9 -d ' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/btrfs_tmp/$subvolume"
      done &&
      echo "deleting /home subvolume" &&
      btrfs subvolume delete /btrfs_tmp/home &&
      echo "restoring blank snapshot" &&
      btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/home

      umount /btrfs_tmp
      rmdir /btrfs_tmp
    '';

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections/"
        "/etc/ssh"
        "/var/lib/bluetooth"
      ];
      files = [
        "/etc/passwd"
        "/etc/shadow"
      ];
    };
  };
}
