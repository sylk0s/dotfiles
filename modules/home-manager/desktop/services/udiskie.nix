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
  cfg = config.modules.desktop.services.udiskie;
in {
  options.modules.desktop.services.udiskie = {
    enable = mk-enable false;
  };

  config = mkIf (cfg.enable) {
    # TODO remove this maybe ???
    nixpkgs.overlays = [
      (self: super: {
        udiskie = super.udiskie.override {
          python3 = super.python3.override {
            packageOverrides = final: prev: {
              keyutils = prev.keyutils.overridePythonAttrs {
                preBuild = ''
                  cython keyutils/_keyutils.pyx
                '';
                preCheck = ''
                  rm -rf keyutils
                '';
                nativeBuildInputs = [final.cython];
                nativeCheckInputs = [final.pytestCheckHook];
              };
            };
          };
        };
      })
    ];

    services.udiskie = {
      enable = true;
      automount = true;
    };

    # callback to callbacks/udisks2.nix
  };
}
