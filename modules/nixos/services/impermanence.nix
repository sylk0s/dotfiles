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

    boot.initrd = {
      enable = true;
      supportedFilesystems = ["btrfs"];

      systemd = {
        enable = true;
        services.restore-root = {
          description = "Rollback btrfs rootfs";
          wantedBy = ["initrd.target"];
          after = [
            # for luks
            "systemd-cryptsetup@${config.networking.hostName}.service"
          ];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script =
            # ''
            #   mkdir -p /mnt
            #   # We first mount the btrfs root to /mnt
            #   # so we can manipulate btrfs subvolumes.
            #   mount -o subvol=/ /dev/vda3 /mnt
            #   # While we're tempted to just delete /root and create
            #   # a new snapshot from /root-blank, /root is already
            #   # populated at this point with a number of subvolumes,
            #   # which makes `btrfs subvolume delete` fail.
            #   # So, we remove them first.
            #   #
            #   # /root contains subvolumes:
            #   # - /root/var/lib/portables
            #   # - /root/var/lib/machines
            #   #
            #   # I suspect these are related to systemd-nspawn, but
            #   # since I don't use it I'm not 100% sure.
            #   # Anyhow, deleting these subvolumes hasn't resulted
            #   # in any issues so far, except for fairly
            #   # benign-looking errors from systemd-tmpfiles.
            #   btrfs subvolume list -o /mnt/root |
            #   cut -f9 -d' ' |
            #   while read subvolume; do
            #     echo "deleting /$subvolume subvolume..."
            #     btrfs subvolume delete "/mnt/$subvolume"
            #   done &&
            #   echo "deleting /root subvolume..." &&
            #   btrfs subvolume delete /mnt/root
            #   echo "restoring blank /root subvolume..."
            #   btrfs subvolume snapshot /mnt/root-blank /mnt/root
            #   # Once we're done rolling back to a blank snapshot,
            #   # we can unmount /mnt and continue on the boot process.
            #   umount /mnt
            # '';
            ''
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
        };
      };
    };

    # boot.initrd.postDeviceCommands = mkAfter
    # (concatLines ([
    #     ''
    #       mkdir /btrfs_tmp
    #       mount -t btrfs /dev/root_vg/root_v /btrfs_tmp

    #       users=$(ls -1 /btrfs/home)

    #       echo "deleting root recursively" &&
    #       btrfs subvolume list -o /btrfs_tmp/root |
    #       cut -f9 -d ' ' |
    #       while read subvolume; do
    #         echo "deleting /$subvolume subvolume..."
    #         btrfs subvolume delete "/btrfs_tmp/$subvolume"
    #       done &&
    #       echo "deleting /root subvolume" &&
    #       btrfs subvolume delete /btrfs_tmp/root &&
    #       echo "restoring blank snapshot" &&
    #       btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/root

    #       echo "deleting home recursively" &&
    #       btrfs subvolume list -o /btrfs_tmp/home |
    #       cut -f9 -d ' ' |
    #       while read subvolume; do
    #         echo "deleting /$subvolume subvolume..."
    #         btrfs subvolume delete "/btrfs_tmp/$subvolume"
    #       done &&
    #       echo "deleting /home subvolume" &&
    #       btrfs subvolume delete /btrfs_tmp/home &&
    #       echo "restoring blank snapshot" &&
    #       btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/home
    #     ''
    #   ]
    #   # ++ (map (user:
    #   #   ''
    #   #     echo "creating ${user.home}"
    #   #     mkdir -p /btrfs_tmp${user.home}
    #   #     chown -R ${user.name}:${user.group} /btrfs_tmp${user.home}
    #   #     chmod ${user.homeMode} /btrfs_tmp${user.home}
    #   #     if [[ ! -e /btrfs_tmp/persist${user.home} ]]; then
    #   #       echo "no persist dir for ${user.name}, creating..."
    #   #       mkdir -p /btrfs_tmp/persist${user.home}
    #   #       chown -R ${user.name}:${user.group} /btrfs_tmp/persist${user.home}
    #   #       chmod ${user.homeMode} /btrfs_tmp/persist${user.home}
    #   #     fi
    #   #     echo "setup env for ${user.name}"
    #   #   '') (attrValues config.users.users))
    #   ++ [
    #     ''
    #       umount /btrfs_tmp
    #       rmdir /btrfs_tmp
    #     ''
    #   ]));

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

    # system.activationScripts.persistent-dir.text = concatLines (map (user:
    #   # optionalString user.createHome
    #   ''

    #     if [[ ! ${user.home} == /var/empty ]]; then
    #       echo "creating ${user.home}"
    #       mkdir -p ${user.home}
    #       chown -R ${user.name}:${user.group} ${user.home}
    #       chmod ${user.homeMode} ${user.home}

    #       if [[ ! -e /persist${user.home} ]]; then
    #         echo "no persist dir for ${user.name}, creating..."
    #         mkdir -p /persist${user.home}
    #         chown -R ${user.name}:${user.group} /persist${user.home}
    #         chmod ${user.homeMode} /persist${user.home}
    #       fi
    #     fi

    #      echo "setup env for ${user.name}"
    #   '') (attrValues config.users.users));
    # };

    # systemd.services.persist-homes = {
    #   description = "Persists home directories";
    #   after = [
    #     "home.mount"
    #   ];
    #   before = [
    #     "home-manager-sylkos.service"
    #   ];
    #   serviceConfig.Type = "oneshot";
    #   script = concatLines (map (user:
    #     # optionalString user.createHome
    #     ''
    #       if [[ ! ${user.home} == /var/empty ]]; then
    #         echo "creating ${user.home}"
    #         mkdir -p ${user.home}
    #         chown -R ${user.name}:${user.group} ${user.home}
    #         chmod ${user.homeMode} ${user.home}

    #         if [[ ! -e /persist${user.home} ]]; then
    #           echo "no persist dir for ${user.name}, creating..."
    #           mkdir -p /persist${user.home}
    #           chown -R ${user.name}:${user.group} /persist${user.home}
    #           chmod ${user.homeMode} /persist${user.home}
    #         fi
    #       fi

    #       echo "setup env for ${user.name}"
    #     '') (attrValues config.users.users));
    # };
  };
}
