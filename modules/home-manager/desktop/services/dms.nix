{
  config,
  lib,
  sylib,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (sylib) mk-enable;
  cfg = config.sylk.desktop.services.dms;

in {
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  options.sylk.desktop.services.dms = {
    enable = mk-enable false;
  };

  config = mkIf cfg.enable {
    programs.dankMaterialShell = {
      enable = true;
      systemd.enable = true;
      niri = {
        enableKeybinds = true;   # Automatic keybinding configuration
      };
    };
  };
}
