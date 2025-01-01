{
  config,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf types mapAttrsToList;
  inherit (builtins) foldl';
  inherit (sylib) mk-enable mk-opt;
  cfg = config.modules.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.impermanence = {
    enable = mk-enable false;
    device = mk-opt types.str "cryptid" "label of luks partition";
  };

  config = mkIf cfg.enable {
    # TODO
    programs.fuse.userAllowOther = true;

    security.sudo.extraConfig = "Defaults lecture=never"; # avoid getting lectured on rollback

    boot.initrd = {
      enable = true;
      systemd.enable = true;
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
          users = foldl' (acc: x: "${acc} ${x.name}") "" config.modules.users;
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
          for user in ${users}; do
              if [[ -e /btrfs_tmp/home/$user ]]; then
                 mkdir -p /btrfs_tmp/old_homes
                 mv /btrfs_tmp/home/$user "/btrfs_tmp/old_homes/$(user)_$(timestamp)"
              fi
          done

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

          # recreates subvolumes
          btrfs subvolume create /btrfs_tmp/root
          btrfs subvolume create /btrfs_tmp/home

          # creates user home directories
          # see https://github.com/NixOS/nixpkgs/issues/6481
          # will be fixed by https://github.com/NixOS/nixpkgs/pull/223932
          for user in ${users}; do
              mkdir /home/$user
              chown $user /home/$user
          done

          umount /btrfs_tmp
        '';
      };
    };

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections/"
        "/etc/ssh"
        "/var/lib/bluetooth"
        "/var/lib/nixos" # for user and group ids
      ];
      files = [
      ];
    };
  };
}
