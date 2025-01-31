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
  cfg = config.sylk.dev.c;
in {
  options.sylk.dev.c = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # clang
      (lib.hiPrio gcc)
      gdb
      gnumake
      cmake
    ];
  };
}
