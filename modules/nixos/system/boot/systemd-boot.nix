{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (sylib) mk-enable;

  cfg = config.sylk.system.boot.systemd-boot;
in {
  options.sylk.system.boot.systemd-boot = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = mkDefault true;

      loader = {
        systemd-boot = {
          enable = mkDefault true;
          configurationLimit = mkDefault 8;
        };

        # efi options from grub
        efi = {
          canTouchEfiVariables = mkDefault true;
          efiSysMountPoint = mkDefault "/efi";
        };
      };
    };
  };
}
