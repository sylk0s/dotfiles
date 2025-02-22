{
  config,
  lib,
  sylib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (sylib) mk-enable;

  cfg = config.sylk.services.git-crypt;
in {
  options.sylk.services.git-crypt = {
    enable = mk-enable true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git-crypt
    ];
  };
}
