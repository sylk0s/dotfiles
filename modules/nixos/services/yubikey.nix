{
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.services.yubikey;
in {
  options.sylk.services.yubikey = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      usbutils # notably, for lsusb
    ];

    services.udev.packages = [
      pkgs.yubikey-personalization
    ];
  };
}
