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
    # any assertions that should be checked
    # assertions = [
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
