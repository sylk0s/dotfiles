{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.pcscd.enable = true;
  };
}
