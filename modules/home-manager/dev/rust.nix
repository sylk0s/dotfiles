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

  cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home = {
      # todo soup up rust config
      packages = with pkgs; [
        clang
        llvmPackages.bintools
        rustup
        # this is outdated :P
        # libcxxabi # for FireDBG <3
      ];

      sessionVariables = {
        # TODO what???
        #PATH = ["$(${pkgs.yarn}/bin/yarn global bin)" "$CARGO_HOME/bin"];

        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
      };
    };
  };
}
