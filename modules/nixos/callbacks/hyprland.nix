{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; {
  config = mkIf (anyUsers (user: user.modules.desktop.hyprland.enable) config.home-manager.users) {
    hardware.opengl.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # this is needed because otherwise I *can't* use my password for this
    # TODO revisit locking stuff
    security.pam.services.swaylock = {
      text = ''
        # PAM configuration file for the swaylock screen locker. By default, it includes
        # the 'login' configuration file (see /etc/pam.d/login)
        auth include login
      '';
    };
  };
}
