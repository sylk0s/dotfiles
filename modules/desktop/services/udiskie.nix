{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.services.udiskie;
in {
  options.modules.desktop.services.udiskie = {
    enable = mkBoolOpt true;
  };

  config = mkIf (cfg.enable) {
    services.udisks2 = {
      enable = true;
    };

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

    home-manager.users.${config.user.name}.services.udiskie = {
      enable = true;
      automount = true;
    };
  };
}
