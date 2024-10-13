{
  config,
  options,
  lib,
  sylib,
  ...
}: let
  cfg = config.modules.ssh;

  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
in {
  options.modules.ssh = {
    enable = mk-enable true;
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
    # other config ...
    services.openssh = {
      enable = true;
      # TODO this is bad. don't do this ever
      ports = [30022];
      openFirewall = false;
    };
  };
}
