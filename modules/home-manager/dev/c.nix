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
  cfg = config.modules.dev.c;
in {
  options.modules.dev.c = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clang
      gcc
      gdb
      cmake
      #llvmPackages.libcxx
    ];
  };
}
