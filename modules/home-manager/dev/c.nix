{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.sylkos; let
  cfg = config.modules.dev.c;
in {
  options.modules.dev.c = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clang
      gcc
      gdb
      cmake
      llvmPackages.libcxx
    ];
  };
}
