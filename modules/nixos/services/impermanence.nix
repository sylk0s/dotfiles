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
      systemd.services.restore-root = {
        description = "Wipes btrfs root";
        wantedBy = ["initrd.target"];
        requires = [
          "dev-vda3"
        ];
        after = [
          "dev-vda3"
          "systemd-cryptsetup@${config.networking.hostName}.service"
        ];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = concatLines ([
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
              mkdir -p /persist/${user.home}
              chown -R ${user.name}:${user.group} /persist/${user.home}
              chmod ${user.homeMode} /persist/${user.home}
              echo "setup env for ${user.name}"
            '') (attrValues config.users.users))
          ++ [
            ''
              umount /btrfs_tmp
              rmdir /btrfs_tmp
            ''
          ]);
      };
    };

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
