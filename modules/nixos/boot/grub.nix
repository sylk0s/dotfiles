{
  config,
  options,
  lib,
  sylib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.modules.grub;
in {
  options.modules.grub = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    boot = {
      kernelPackages = mkDefault pkgs.linuxPackages_latest;

      loader = {
        efi = {
          canTouchEfiVariables = mkDefault true;
          efiSysMountPoint = mkDefault "/boot/efi";
        };

        grub = {
          enable = mkDefault true;
          devices = ["nodev"];
          efiSupport = mkDefault true;
          useOSProber = mkDefault true;
          configurationLimit = mkDefault 10;
          #copyKernels = mkDefault true; # TODO make this dependent on encryption maybe
          enableCryptodisk = mkDefault true;
        };

        timeout = mkDefault null;
      };
    };
  };
}
