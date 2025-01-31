{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.system.bluetooth;
in {
  options.sylk.system.bluetooth = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    # TODO tie into DE
    services.blueman.enable = true;
  };
}
