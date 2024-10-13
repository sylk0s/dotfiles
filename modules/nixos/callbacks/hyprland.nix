{
  lib,
  sylib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) any-users;
in {
  config = mkIf (any-users (user: user.modules.desktop.hyprland.enable) config.home-manager.users) {
    #hardware.opengl.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # this is needed because otherwise I *can't* use my password for this
    # TODO revisit locking stuff
    security.pam.services.swaylock = {};
  };
}
