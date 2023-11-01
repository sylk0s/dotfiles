{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
      user.packages = with pkgs; [ 
              clang
                llvmPackages.bintools
                rustup 
            ];

      env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

      env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      
            environment.variables.PATH = [ "$CARGO_HOME/bin" ];
    };
}
