{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.bluetooth;
in {
  options.modules.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # any assertations that should be checked
    # assertations = [
    #   {
    #     assertion = true;
    #     message = "";
    #   }
    #   # ...
    # ];

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    # TODO tie into DE
    services.blueman.enable = true;
  };
}
