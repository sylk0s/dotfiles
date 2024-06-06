{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.dev.embedded;
in {
  options.modules.dev.embedded = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # gcc for arm embedded (duh)
      gcc-arm-embedded

      # on chip debugger
      openocd

      screen
      usbutils

      stlink
      stm32cubemx

      pico-sdk

      platformio

      # zephyr
      python311Packages.west
    ];

    # callback to callbacks/embedded.nix
  };
}
