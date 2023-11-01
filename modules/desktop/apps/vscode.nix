{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.vscode;
in {
    options.modules.desktop.apps.vscode = {
        enable = mkBoolOpt true;
    };

    config = mkIf cfg.enable {
        user.packages = with pkgs; [
            vscode
        ];
    # in ~/.config/Code/User/settings.json
    #       {
    #           "window.titleBarStyle": "custom",
    #           ...
    #       }
            
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
    };

}
