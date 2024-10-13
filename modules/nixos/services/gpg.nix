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

  cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.pcscd.enable = true;
  };
}
