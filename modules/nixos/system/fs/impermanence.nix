{
  config,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf types mkDefault mkOption;
  inherit (builtins) foldl';
  inherit (sylib) mk-enable mk-opt mk-str-opt;
  cfg = config.sylk.system.fs.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.sylk.system.fs.impermanence = {
    enable = mk-enable false;
    persist-dir = mk-str-opt "/persist";
    dirs-to-persist = mkOption {
      type = types.listOf types.str;
      description = "The directories to persist";
      default = [];
    };
    files-to-persist = mkOption {
      type = types.listOf types.str;
      description = "The files to persist";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.sylk.system.fs.ephemeral-btrfs.enable;
        message = "Impermanence requires an ephemeral file system!";
      }
    ];

    programs.fuse.userAllowOther = mkDefault true;

    security.sudo.extraConfig = "Defaults lecture=never"; # avoid getting lectured on rollback

    environment.persistence."${cfg.persist-dir}" = {
      enable = true;
      hideMounts = true;
      directories =
        [
          "/etc/NetworkManager/system-connections/"
          "/etc/ssh"
          "/var/lib/bluetooth"
          "/var/lib/nixos" # for user and group ids
          "/var/lib/systemd/backlight"
        ]
        ++ cfg.dirs-to-persist;
      files =
        [
        ]
        ++ cfg.files-to-persist;
    };
  };
}
