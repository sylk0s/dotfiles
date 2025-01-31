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

  cfg = config.sylk.dev.rust;
in {
  options.sylk.dev.rust = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    home = {
      # todo soup up rust config
      packages = with pkgs; [
        # rust toolchain
        cargo
        rustc
        rustfmt
        clippy
        rust-analyzer

        # for lld
        llvmPackages.bintools
      ];

      sessionVariables = {
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$HOME/.local/state/cargo";
      };

      sessionPath = [
        "$CARGO_HOME/bin"
      ];

      persistence."/persist/home/${config.home.username}" = {
        directories = [
          ".local/state/cargo"
        ];
      };
    };
  };
}
