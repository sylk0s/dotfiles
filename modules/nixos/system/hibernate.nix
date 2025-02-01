{
  config,
  lib,
  sylib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (sylib) mk-enable;

  cfg = config.sylk.system.hibernate;
in {
  options.sylk.system.hibernate = {
    enable = mk-enable false;
    resume-offset = mkOption {
      type = types.int;
      default = 0;
      description = "" "

            " "";
    };
    resume-device = mk-str-opt "/dev/disk/by-label/NIXROOT";
  };

  config = mkIg cfg.enable {
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
