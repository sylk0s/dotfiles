{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf mkDefault foldl' types;
  inherit (sylib) mk-enable mk-opt;

  cfg = config.sylk.system.fs.ephemeral-btrfs;
in {
  options.sylk.system.fs.ephemeral-btrfs = {
    enable = mk-enable false;
    device = mk-opt types.str "cryptid" "label of luks partition";
  };

  config = mkIf cfg.enable {
    boot.initrd = {
      enable = mkDefault true;
      systemd.enable = mkDefault true;
      supportedFilesystems = ["btrfs"];

      systemd.services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          # LUKS/TPM process
          "systemd-cryptsetup@${cfg.device}.service"
          "initrd-root-device.target"
        ];
        before = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = let
          # list of users on this system
          users = foldl' (acc: x: "${acc} ${x.name}") "" config.sylk.users;
        in ''
          mkdir /btrfs_tmp
          mount /dev/mapper/${cfg.device} /btrfs_tmp

          # create the user persistent dirs if needed for HM

          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")

          # reset root
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          # reset home
          if [[ -e /btrfs_tmp/home ]]; then
              mkdir -p /btrfs_tmp/old_homes
              mv /btrfs_tmp/home "/btrfs_tmp/old_homes/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          # deletes old saved roots
          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          # deletes old saved homes
          for i in $(find /btrfs_tmp/old_homes/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          # deletes old saved persist
          # this only saves a week as opposed to the others, which save a month
          #for i in $(find /btrfs_tmp/old_persist/ -maxdepth 1 -mtime +7); do
          #    delete_subvolume_recursively "$i"
          #done

          # recreates subvolumes
          btrfs subvolume create /btrfs_tmp/root
          btrfs subvolume create /btrfs_tmp/home

          btrfs subvolume snapshot /btrfs_tmp/persist "/btrfs_tmp/old_persist/$timestamp"

          for i in $(find /btrfs_tmp/old_persist/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          # NOTE: This bug wasn't fixed, I made home needed for boot to fix this issue
          # creates user home directories
          # see https://github.com/NixOS/nixpkgs/issues/6481
          # will be fixed by https://github.com/NixOS/nixpkgs/pull/223932
          # for user in ${users}; do
          #     mkdir /btrfs_tmp/home/$user
          #     chown $user /btrfs_tmp/home/$user
          # done

          umount /btrfs_tmp
        '';
      };
    };
  };
}
