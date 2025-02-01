{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  inherit (sylib) mk-enable mk-str-opt;

  cfg = config.sylk.system.hibernate;
in {
  options.sylk.system.hibernate = {
    enable = mk-enable false;
    resume-offset = mkOption {
      type = types.int;
      default = 0;
      description = ''
        The offset into the swapfile to resume from.
        Determined from this link according to your FS type:
        https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
      '';
    };
    resume-device = mk-str-opt "/dev/disk/by-label/NIXROOT";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = ["resume_offset=${toString cfg.resume-offset}"];
      resumeDevice = cfg.resume-device;
    };
    systemd.sleep.extraConfig = ''
      [Sleep]
      HibernateMode=shutdown
    '';

    assertions = [
      {
        assertion = (builtins.length config.swapDevices) != 0;
        message = "Hibernation requires a swapfile configured to hibernate to";
      }
    ];
  };
}
