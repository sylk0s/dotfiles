{
  config,
  options,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.modules.dev.embedded;
in {
  options.modules.dev.embedded = {
    enable = mk-enable false;
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
