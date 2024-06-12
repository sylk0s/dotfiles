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
    programs.fuse.userAllowOther = true;

    boot.initrd.postDeviceCommands = mkAfter (concatLines ([
        ''
          mkdir /btrfs_tmp
          mount -t btrfs /dev/root_vg/root_v /btrfs_tmp

          users=$(ls -1 /btrfs/home)

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
        ''
      ]
      ++ (map (user:
        optionalString user.createHome ''
          echo "creating /${user.home}"
          mkdir -p /btrfs_tmp/${user.home}
          chown -R ${user.name}:${user.group} /btrfs_tmp/${user.home}
          chmod ${user.homeMode} /btrfs_tmp/${user.home}

          if [[ ! -e /btrfs_tmp/persist/${user.home} ]]; then
            mkdir -p /btrfs_tmp/persist/${user.home}
            chown -R ${user.name}:${user.group} /btrfs_tmp/persist/${user.home}
            chmod ${user.homeMode} /btrfs_tmp/persist/${user.home}
          fi

          echo "setup env for ${user.name}"
        '') (attrValues config.users.users))
      ++ [
        ''
          umount /btrfs_tmp
          rmdir /btrfs_tmp
        ''
      ]));

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections/"
        "/etc/ssh"
        "/var/lib/bluetooth"
      ];
      files = [
      ];
    };

    # system.activationScripts.persistent-dir.text = let
    #   mkHomePersist = user:
    #     optionalString user.createHome ''
    #       mkdir -p /persist/${user.home}
    #       chown -R ${user.name}:${user.group} /persist/${user.home}
    #       chmod ${user.homeMode} /persist/${user.home}
    #     '';
    #   users = attrValues config.users.users;
    # in
    #   concatLines (map mkHomePersist users);
  };
}
