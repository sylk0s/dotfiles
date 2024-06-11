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
    boot.initrd.postDeviceCommands = mkBefore ''
      mkdir /btrfs_tmp
      mount -t btrfs -o subvol=root /dev/root_vg/root_v /btrfs_tmp

      echo "deleting recursively" &&
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

      umount /btrfs_tmp
      rmdir /btrfs_tmp
    '';

    # btrfs subvolume delete /btrfs_tmp/root
    #       btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/root

    # btrfs subvolume delete /btrfs_tmp/home
    #   btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/home

    # if [[ -e /btrfs_tmp/root ]]; then
    #   mkdir -p /btrfs_root/old_roots
    #   timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
    #   mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    # fi

    # delete_subvolute_rec() {
    #   IFS=$'\n'
    #   for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #     delete_subvolume_rec "/btrfs_tmp/$i"
    #   done
    #   btrfs subvolume delete "$1"
    # }

    # for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #   delete_subvolume_rec "$i"
    # done

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections/"
        "/etc/ssh"
        "/var/lib/bluetooth"
      ];
      # files = [
      #   "/etc/"
      # ];
    };
  };
}
