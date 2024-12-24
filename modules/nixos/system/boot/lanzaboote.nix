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

  cfg = config.modules.lanzaboote;
in {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.modules.lanzaboote = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    boot = {
      bootspec.enable = true;

      initrd.systemd.enable = true;

      loader.systemd-boot.enable = lib.mkForce false;

      # efi options from grub
      efi = {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = mkDefault "/boot/efi";
      };

      # latest kernal packages

      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };

    environment.systemPackages = [
      pkgs.sbctl
    ];
  };
}
