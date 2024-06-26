{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkBoolOpt true;
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
