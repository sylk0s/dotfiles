{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (sylib) mk-enable;

  cfg = config.modules.systemd-boot;
in {
  options.modules.systemd-boot = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = mkDefault true;

      loader = {
        systemd-boot.enable = mkDefault true;

        # efi options from grub
        efi = {
          canTouchEfiVariables = mkDefault true;
          efiSysMountPoint = mkDefault "/efi";
        };
      };
    };
  };
}
