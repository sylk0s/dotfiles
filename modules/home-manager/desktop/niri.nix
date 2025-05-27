{
  lib,
  sylib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;

  cfg = config.sylk.desktop.niri;
in {
  options.sylk.desktop.niri = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    sylk.desktop = {
      apps.hyprlock.enable = true;
      services = {
        wpaperd.enable = true;
        hypridle.enable = true;
      };
    };

    # programs.niri = {
    #   enable = true;
    # };
  };
}
